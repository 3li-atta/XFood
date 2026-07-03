import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:io' as io;
import '../bloc/backup_bloc.dart';
import '../bloc/backup_event.dart';
import '../bloc/backup_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/auto_backup_manager.dart';

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

class _BackupView extends StatefulWidget {
  const _BackupView();

  @override
  State<_BackupView> createState() => _BackupViewState();
}

class _BackupViewState extends State<_BackupView> {
  bool _autoBackupEnabled = false;
  String _autoBackupFrequency = 'Daily';
  bool _isLoadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadAutoBackupSettings();
  }

  Future<void> _loadAutoBackupSettings() async {
    final settings = await AutoBackupManager.loadSettings();
    setState(() {
      _autoBackupEnabled = settings['enabled'];
      _autoBackupFrequency = settings['frequency'];
      _isLoadingSettings = false;
    });
  }

  Future<void> _toggleAutoBackup(bool val) async {
    setState(() {
      _autoBackupEnabled = val;
    });
    await AutoBackupManager.saveSettings(val, _autoBackupFrequency);
  }

  Future<void> _changeFrequency(String? val) async {
    if (val == null) return;
    setState(() {
      _autoBackupFrequency = val;
    });
    await AutoBackupManager.saveSettings(_autoBackupEnabled, val);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي والاستعادة السحابية'),
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

                  if (state.isAuthenticated && (io.Platform.isAndroid || io.Platform.isIOS)) ...[
                    // Auto-Backup Settings Card
                    _isLoadingSettings
                        ? const Center(child: CircularProgressIndicator())
                        : Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.sync,
                                        color: Color(0xFF1E3A8A),
                                        size: 28,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'إعدادات النسخ الاحتياطي التلقائي',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                      'تفعيل النسخ الاحتياطي التلقائي',
                                      style: TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: const Text(
                                      'يتم نسخ قاعدة البيانات تلقائيًا في الخلفية عند الاتصال بشبكة Wi-Fi أو بيانات الجوال.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: _autoBackupEnabled,
                                    onChanged: _toggleAutoBackup,
                                    activeColor: const Color(0xFF10B981),
                                  ),
                                  if (_autoBackupEnabled) ...[
                                    const Divider(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            'معدل تكرار النسخ الاحتياطي:',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        DropdownButton<String>(
                                          value: _autoBackupFrequency,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Daily',
                                              child: Text('يومي'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Every 3 days',
                                              child: Text('كل 3 أيام'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Weekly',
                                              child: Text('أسبوعي'),
                                            ),
                                          ],
                                          onChanged: _changeFrequency,
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),

                    // Backups List Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'النسخ الاحتياطية المتاحة',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: 'تحديث القائمة',
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
                              'لم يتم العثور على نسخ احتياطية على Google Drive.\nاضغط على "إنشاء نسخة احتياطية جديدة الآن" لحفظ قاعدة البيانات الحالية.',
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
                              title: Text(
                                backup.fileName,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text('$formattedDate • $sizeMB ميجابايت', style: const TextStyle(fontSize: 12)),
                              trailing: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                icon: const Icon(Icons.settings_backup_restore, size: 16),
                                label: const Text('استعادة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                'الاتصال بـ Google Drive',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'اربط حساب Google Drive الخاص بك لنسخ المبيعات، والوجبات، والمخزون، وبيانات السجل بأمان خارج الإنترنت. واستعادتها في أي وقت على جهاز آخر.',
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
                label: const Text('تسجيل الدخول باستخدام Google', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        'تم الاتصال بـ Google Drive',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.email ?? 'تم تسجيل الدخول',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.read<BackupBloc>().add(SignOutFromGoogle()),
                  child: const Text('قطع الاتصال', style: TextStyle(color: Colors.red)),
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
                label: const Text('إنشاء نسخة احتياطية جديدة الآن', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
        title: const Text('تأكيد الاستعادة؟'),
        content: const Text(
          'تحذير: ستؤدي استعادة هذه النسخة الاحتياطية إلى استبدال قاعدة البيانات المحلية الحالية بالكامل. ستفقد أي مبيعات أو تغييرات غير محفوظة تم إجراؤها منذ النسخ الاحتياطي. سيتم إعادة تشغيل التطبيق تلقائيًا بعد الاستعادة.\n\nهل أنت متأكد أنك تريد الاستمرار؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(TriggerRestore(fileId));
            },
            child: const Text('استعادة وإعادة تشغيل التطبيق', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
