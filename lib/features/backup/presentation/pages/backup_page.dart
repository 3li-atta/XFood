import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import '../bloc/backup_bloc.dart';
import '../bloc/backup_event.dart';
import '../bloc/backup_state.dart';
import '../../../../core/di/injection.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BackupBloc>()..add(CheckBackupAuth()),
      child: const _BackupView(),
    );
  }
}

class _BackupView extends StatelessWidget {
  const _BackupView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Backup & Restore'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pos'),
        ),
      ),
      body: BlocConsumer<BackupBloc, BackupState>(
        listener: (context, state) {
          if (state is BackupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state is BackupOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✓ ${state.message}'),
                backgroundColor: Colors.green,
              ),
            );
            if (state.shouldRestart) {
              Future.delayed(const Duration(seconds: 2), () {
                Restart.restartApp();
              });
            }
          }
        },
        builder: (context, state) {
          if (state is BackupLoading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(state.message, style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }

          if (state is BackupLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Auth Section
                  _buildAuthCard(context, state, theme, colorScheme),
                  const SizedBox(height: 24),

                  if (state.isAuthenticated) ...[
                    // Backups List Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Backups',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Refresh list',
                          onPressed: () => context.read<BackupBloc>().add(LoadBackupHistory()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Backups list
                    if (state.backups.isEmpty)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                              'No backups found on Google Drive.\nPress "Create Backup" to save your current database.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.backups.length,
                        itemBuilder: (context, index) {
                          final backup = state.backups[index];
                          final formattedDate = DateFormat('MMM dd, yyyy – HH:mm').format(backup.createdAt);
                          final sizeMB = (backup.sizeInBytes / (1024 * 1024)).toStringAsFixed(2);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFEFF6FF),
                                child: Icon(Icons.storage, color: Color(0xFF1E3A8A)),
                              ),
                              title: Text(backup.fileName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              subtitle: Text('$formattedDate • $sizeMB MB', style: const TextStyle(fontSize: 12)),
                              trailing: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.settings_backup_restore, size: 16),
                                label: const Text('Restore', style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () => _confirmRestore(context, backup.fileId),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAuthCard(BuildContext context, BackupLoaded state, ThemeData theme, ColorScheme colorScheme) {
    if (!state.isAuthenticated) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.cloud_queue, size: 64, color: Color(0xFF1E3A8A)),
              const SizedBox(height: 16),
              Text(
                'Connect to Google Drive',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Link your Google Drive account to backup your offline sales, meals, stock, and history data safely. Restore it anytime on another device.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.read<BackupBloc>().add(SignInWithGoogle()),
                icon: const Icon(Icons.login),
                label: const Text('Sign In with Google', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  radius: 24,
                  child: Icon(Icons.cloud_done, color: Color(0xFF10B981)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Google Drive Connected',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.email ?? 'Authenticated',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<BackupBloc>().add(SignOutFromGoogle()),
                  child: const Text('Disconnect', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () => context.read<BackupBloc>().add(TriggerBackup()),
                icon: const Icon(Icons.backup),
                label: const Text('Create New Backup Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRestore(BuildContext context, String fileId) {
    final bloc = context.read<BackupBloc>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Restore?'),
        content: const Text(
          'WARNING: Restoring this backup will completely overwrite your current local database. Any unsaved sales or changes made since the backup will be lost. The app will restart automatically after restoration.\n\nAre you sure you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(TriggerRestore(fileId));
            },
            child: const Text('Restore & Restart App', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
