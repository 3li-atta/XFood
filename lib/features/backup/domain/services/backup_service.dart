/// Metadata for a database backup file on Google Drive.
class BackupMetadata {
  final String fileId;
  final String fileName;
  final DateTime createdAt;
  final int sizeInBytes;

  const BackupMetadata({
    required this.fileId,
    required this.fileName,
    required this.createdAt,
    required this.sizeInBytes,
  });
}

/// Interface defining the cloud database backup and restore operations.
abstract class BackupService {
  /// Prompts Google Sign-In and requests Google Drive scopes.
  Future<bool> authenticate();

  /// Logs out the user from Google.
  Future<void> signOut();

  /// Gets the currently authenticated user's email.
  Future<String?> get currentUserEmail;

  /// Checks if the client has a valid authenticated session.
  Future<bool> get isClientAuthenticated;

  /// Backs up the local SQLite database file to Google Drive appDataFolder.
  ///
  /// Returns the Drive file ID if successful, or null on failure.
  Future<String?> backupDatabase();

  /// Fetches a list of backup files stored in Google Drive appDataFolder.
  Future<List<BackupMetadata>> listBackups();

  /// Downloads the specified database file from Google Drive and replaces the local SQLite database file.
  ///
  /// Returns true if successful.
  Future<bool> restoreDatabase(String fileId);
}
