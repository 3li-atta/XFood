import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';

class ClientSetupWidget extends StatelessWidget {
  final DeviceSettingsState state;
  final ColorScheme colors;
  final TextEditingController ipController;
  final TextEditingController portController;
  final TextEditingController pinController;
  final VoidCallback onScanQr;

  const ClientSetupWidget({
    super.key,
    required this.state,
    required this.colors,
    required this.ipController,
    required this.portController,
    required this.pinController,
    required this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'عنوان الخادم الرئيسي (Master Address)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 18),
                  label: const Text('اقتران الـ QR Code', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  onPressed: onScanQr,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ipController,
              decoration: const InputDecoration(
                labelText: 'عنوان IP للخادم الرئيسي',
                hintText: 'مثال: 192.168.1.100',
                prefixIcon: Icon(Icons.wifi_lock_rounded),
              ),
              onChanged: (val) {
                final port = int.tryParse(portController.text) ?? 8080;
                context.read<DeviceSettingsBloc>().add(UpdateMasterAddress(val, port));
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'منفذ الخادم (Port)',
                hintText: 'المنفذ الافتراضي 8080',
                prefixIcon: Icon(Icons.power_input_rounded),
              ),
              onChanged: (val) {
                final port = int.tryParse(val) ?? 8080;
                context.read<DeviceSettingsBloc>().add(UpdateMasterAddress(ipController.text, port));
              },
            ),
            const Divider(height: 32),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: state.isTestingConnection
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.network_check_rounded, size: 18),
                label: const Text('اختبار إمكانية الوصول بالخادم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                onPressed: state.isTestingConnection
                    ? null
                    : () {
                        context.read<DeviceSettingsBloc>().add(TestConnection());
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
