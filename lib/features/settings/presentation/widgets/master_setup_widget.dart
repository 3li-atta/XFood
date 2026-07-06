import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';

class MasterSetupWidget extends StatelessWidget {
  final DeviceSettingsState state;
  final ColorScheme colors;

  const MasterSetupWidget({
    super.key,
    required this.state,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final isRunning = state.isServerRunning;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تهيئة وتشغيل خادم الكاشير الرئيسي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'تشغيل الخادم سيتيح لباقي نقاط البيع الاستعلام وإرسال الفواتير والمزامنة.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isRunning ? colors.secondary : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isRunning ? 'الخادم نشط حالياً' : 'الخادم غير نشط',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isRunning ? colors.secondary : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? colors.error : colors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Icon(isRunning ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 18),
                  label: Text(
                    isRunning ? 'إيقاف الخادم' : 'تشغيل الخادم',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    context.read<DeviceSettingsBloc>().add(
                          isRunning ? StopServerEvent() : StartServerEvent(),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
