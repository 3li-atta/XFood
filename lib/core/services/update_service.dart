import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  final String latestVersion;
  final String apkUrl;
  final List<String> changelog;

  UpdateInfo({
    required this.latestVersion,
    required this.apkUrl,
    required this.changelog,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    return UpdateInfo(
      latestVersion: json['latest_version'] as String,
      apkUrl: json['apk_url'] as String,
      changelog: List<String>.from(json['changelog'] ?? []),
    );
  }
}

class UpdateService {
  final Dio _dio = Dio();
  
  // Replace these with your GitHub account details when you upload the repo!
  static const String githubOwner = '3li-atta';
  static const String githubRepo = 'XFood';

  static const String _updateUrl = 'https://api.github.com/repos/$githubOwner/$githubRepo/releases/latest';

  /// Checks if a new version is available compared to the current version.
  Future<UpdateInfo?> checkForUpdate() async {
    try {
      final response = await _dio.get(
        _updateUrl,
        options: Options(
          headers: {
            'Accept': 'application/vnd.github+json',
          },
        ),
      );
      if (response.statusCode != 200) return null;

      final data = response.data as Map<String, dynamic>;
      final tagName = data['tag_name'] as String; // e.g., "v1.0.6" or "1.0.6"
      final cleanVersion = tagName.replaceAll('v', ''); // Remove 'v' prefix

      // Find the APK file in the release assets
      final assets = data['assets'] as List<dynamic>;
      String? apkUrl;
      for (final asset in assets) {
        final name = asset['name'] as String;
        if (name.endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String;
          break;
        }
      }

      if (apkUrl == null) return null;

      // Use release description (body) as the changelog
      final body = data['body'] as String? ?? 'Bug fixes and performance improvements.';
      final changelog = body
          .split('\n')
          .map((line) => line.replaceAll('\r', '').trim())
          .where((line) => line.isNotEmpty)
          .toList();

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      if (_isVersionNewer(cleanVersion, currentVersion)) {
        return UpdateInfo(
          latestVersion: cleanVersion,
          apkUrl: apkUrl,
          changelog: changelog,
        );
      }
    } catch (_) {
      // Fail silently
    }
    return null;
  }

  /// Downloads the APK from [apkUrl] and reports progress.
  Future<File?> downloadApk(String apkUrl, Function(double progress) onProgress) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final apkPath = '${tempDir.path}/xfood_update.apk';
      final apkFile = File(apkPath);

      if (await apkFile.exists()) {
        await apkFile.delete();
      }

      final response = await _dio.download(
        apkUrl,
        apkPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      if (response.statusCode == 200) {
        return apkFile;
      }
    } catch (_) {
      // Fail silently
    }
    return null;
  }

  /// Triggers the Android package installer to install the downloaded APK.
  Future<void> installApk(File apkFile) async {
    await OpenFilex.open(
      apkFile.path,
      type: "application/vnd.android.package-archive",
    );
  }

  /// Compares two semantic versions. Returns true if [latest] is newer than [current].
  bool _isVersionNewer(String latest, String current) {
    try {
      final latestParts = latest.split('.').map(int.parse).toList();
      final currentParts = current.split('.').map(int.parse).toList();

      for (var i = 0; i < latestParts.length; i++) {
        if (i >= currentParts.length) return true;
        if (latestParts[i] > currentParts[i]) return true;
        if (latestParts[i] < currentParts[i]) return false;
      }
    } catch (_) {
      // Fallback simple comparison
      return latest != current;
    }
    return false;
  }
}
