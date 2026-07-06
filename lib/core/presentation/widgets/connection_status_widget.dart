import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';

/// Small visual indicator for client devices displaying the LAN synchronization status.
///
/// Tapping the status indicator routes the user to the device settings page
/// to easily modify IP connection parameters or check networking.
class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceConfig = getIt<DeviceConfigService>();
    
    // Server/Master device doesn't need to show client-specific sync state.
    if (deviceConfig.isMaster) {
      return const SizedBox.shrink();
    }

    final clientService = getIt<LanClientService>();

    return StreamBuilder<LanConnectionState>(
      stream: clientService.stateStream,
      initialData: clientService.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? LanConnectionState.disconnected;

        Color backgroundColor;
        Color textColor;
        String statusText;
        IconData icon;

        switch (state) {
          case LanConnectionState.connected:
            backgroundColor = Colors.green.shade50;
            textColor = Colors.green.shade800;
            statusText = 'متصل بالشبكة المحلية';
            icon = Icons.cloud_done;
            break;
          case LanConnectionState.connecting:
            backgroundColor = Colors.orange.shade50;
            textColor = Colors.orange.shade800;
            statusText = 'جاري الاتصال بالخادم...';
            icon = Icons.sync;
            break;
          case LanConnectionState.disconnected:
          case LanConnectionState.error:
            backgroundColor = Colors.red.shade50;
            textColor = Colors.red.shade800;
            statusText = 'غير متصل - اضغط للربط';
            icon = Icons.cloud_off;
            break;
        }

        return InkWell(
          onTap: () {
            context.push('/settings/device');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: textColor),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
