import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite3/sqlite3.dart' as sqlite;
import '../../../../core/di/injection.dart';
import '../../../../database/app_database.dart';
import '../../domain/services/backup_service.dart';

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleDriveBackupService implements BackupService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      drive.DriveApi.driveAppdataScope,
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  Future<bool> authenticate() async {
    _currentUser = await _googleSignIn.signIn();
    return _currentUser != null;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  @override
  Future<String?> get currentUserEmail async {
    if (_currentUser == null) {
      _currentUser = _googleSignIn.currentUser;
    }
    return _currentUser?.email;
  }

  @override
  Future<bool> get isClientAuthenticated async {
    if (_currentUser == null) {
      _currentUser = _googleSignIn.currentUser;
    }
    return _currentUser != null;
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    if (_currentUser == null) {
      _currentUser = await _googleSignIn.signInSilently();
    }
    if (_currentUser == null) return null;

    final authHeaders = await _currentUser!.authHeaders;
    final httpClient = GoogleHttpClient(authHeaders);
    return drive.DriveApi(httpClient);
  }

  @override
  Future<String?> backupDatabase() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) throw Exception('User not authenticated.');

    // ── Checkpoint WAL before backing up ──
    try {
      final db = getIt<AppDatabase>();
      await db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    } catch (_) {
      // Ignore if DB is not initialized yet or closed
    }

    // 1. Get database path
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'xfood_pos.sqlite');
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) {
      throw Exception('Local database file not found.');
    }

    // 2. Prepare upload payload
    final fileMetadata = drive.File()
      ..name = 'xfood_backup_${DateTime.now().toIso8601String().replaceAll(':', '-')}.sqlite'
      ..parents = ['appDataFolder']; // upload to isolated App Data folder

    final media = drive.Media(
      dbFile.openRead(),
      await dbFile.length(),
    );

    // 3. Upload to Google Drive
    final uploadedFile = await driveApi.files.create(
      fileMetadata,
      uploadMedia: media,
    );

    return uploadedFile.id;
  }

  @override
  Future<List<BackupMetadata>> listBackups() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) throw Exception('User not authenticated.');

      // List files inside appDataFolder with explicit fields
      final fileList = await driveApi.files.list(
        spaces: 'appDataFolder',
        q: "name contains 'xfood_backup_'",
        orderBy: 'createdTime desc',
        $fields: 'files(id, name, createdTime, size)',
      );

      if (fileList.files == null) return [];

      return fileList.files!.map((f) {
        return BackupMetadata(
          fileId: f.id ?? '',
          fileName: f.name ?? '',
          createdAt: f.createdTime ?? DateTime.now(),
          sizeInBytes: int.tryParse(f.size ?? '0') ?? 0,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> restoreDatabase(String fileId) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) throw Exception('User not authenticated.');

    // 1. Fetch file stream
    final response = await driveApi.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    // 2. Prepare temp path to write downloaded database safely
    final dbFolder = await getApplicationDocumentsDirectory();
    final tempPath = p.join(dbFolder.path, 'xfood_pos_restore_temp.sqlite');
    final tempFile = File(tempPath);

    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    // 3. Write download chunks
    final sink = tempFile.openWrite();
    await response.stream.forEach((chunk) => sink.add(chunk));
    await sink.close();

    // 4. Validate database integrity using sqlite3
    try {
      final sqliteDb = sqlite.sqlite3.open(tempPath);
      final result = sqliteDb.select('PRAGMA integrity_check');
      sqliteDb.dispose();

      if (result.isEmpty || result.first.values.first != 'ok') {
        throw Exception('Database integrity check failed: $result');
      }
    } catch (e) {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      throw Exception('Downloaded database file is corrupted or invalid: $e');
    }

    // 5. Safely close database connection before swapping files
    final liveDbPath = p.join(dbFolder.path, 'xfood_pos.sqlite');
    final liveDbFile = File(liveDbPath);
    final bakDbPath = p.join(dbFolder.path, 'xfood_pos.sqlite.bak');
    final bakDbFile = File(bakDbPath);

    // Backup active DB
    if (await liveDbFile.exists()) {
      if (bakDbFile.existsSync()) {
        bakDbFile.deleteSync();
      }
      await liveDbFile.copy(bakDbPath);
    }

    try {
      final db = getIt<AppDatabase>();
      await db.close();
    } catch (_) {
      // Ignore if already closed or not initialized
    }

    // 6. Delete live database, WAL, and SHM files to prevent recovery corruption
    try {
      if (await liveDbFile.exists()) {
        await liveDbFile.delete();
      }

      final walFile = File('$liveDbPath-wal');
      if (await walFile.exists()) {
        await walFile.delete();
      }

      final shmFile = File('$liveDbPath-shm');
      if (await shmFile.exists()) {
        await shmFile.delete();
      }

      // Rename temp file to live
      await tempFile.rename(liveDbPath);

      // Clean up backup on success
      if (bakDbFile.existsSync()) {
        bakDbFile.deleteSync();
      }
      return true;
    } catch (e) {
      // Rollback on failure
      if (bakDbFile.existsSync()) {
        if (liveDbFile.existsSync()) {
          liveDbFile.deleteSync();
        }
        await bakDbFile.rename(liveDbPath);
      }
      throw Exception('Failed to replace database file: $e');
    }
  }
}
