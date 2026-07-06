import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MasterActivePanel extends StatelessWidget {
  final DeviceSettingsState state;
  final ColorScheme colors;
  final String pairingUri;

  const MasterActivePanel({
    super.key,
    required this.state,
    required this.colors,
    required this.pairingUri,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = state.isServerRunning;
    if (!isRunning) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.warning_amber_rounded, size: 48, color: colors.error),
            const SizedBox(height: 12),
            const Text(
              'الخادم المحلي غير نشط حالياً!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              'يرجى الرجوع للخطوة السابقة وتفعيل تشغيل الخادم.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('العنوان النشط للخادم:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        SelectableText(
                          '${state.serverIp ?? '0.0.0.0'}:${state.masterPort}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: '${state.serverIp ?? '0.0.0.0'}:${state.masterPort}'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم نسخ عنوان الخادم!'), behavior: SnackBarBehavior.floating),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(height: 28),
                QrImageView(
                  data: pairingUri,
                  version: QrVersions.auto,
                  size: 150,
                  foregroundColor: colors.primary,
                ),
                const SizedBox(height: 10),
                const Text(
                  'رمز الاقتران السريع المكتمل للشبكة الفرعية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الأجهزة الفرعية النشطة المتصلة حالياً:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${state.clientCount} أجهزة',
                    style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
