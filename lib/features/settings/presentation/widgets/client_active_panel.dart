import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nsd/nsd.dart' as nsd;
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';

class ClientActivePanel extends StatelessWidget {
  final DeviceSettingsState state;
  final ColorScheme colors;
  final TextEditingController ipController;
  final TextEditingController portController;
  final VoidCallback onScanQr;

  const ClientActivePanel({
    super.key,
    required this.state,
    required this.colors,
    required this.ipController,
    required this.portController,
    required this.onScanQr,
  });

  @override
  Widget build(BuildContext context) {
    final isConnected = state.connectionState == LanConnectionState.connected;
    final isConnecting = state.connectionState == LanConnectionState.connecting;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Text('الخادم المستهدف للاتصال:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text(
                          '${state.masterIp}:${state.masterPort}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                    if (!isConnected)
                      IconButton.filledTonal(
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                        onPressed: onScanQr,
                      ),
                  ],
                ),
                const Divider(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected ? colors.error : colors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(isConnected ? Icons.link_off_rounded : Icons.link_rounded),
                    label: Text(
                      isConnected
                          ? 'قطع الاتصال بالخادم الرئيسي'
                          : (isConnecting ? 'جاري الاتصال بالخادم...' : 'بدء الاتصال بالخادم الرئيسي'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: isConnecting
                        ? null
                        : () {
                            context.read<DeviceSettingsBloc>().add(
                                  isConnected ? DisconnectFromMasterEvent() : ConnectToMasterEvent(),
                                );
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'الخوادم النشطة المكتشفة بالشبكة تلقائياً:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
        ),
        const SizedBox(height: 10),
        _buildAutoDiscoverySection(context),
      ],
    );
  }

  Widget _buildAutoDiscoverySection(BuildContext context) {
    if (state.discoveredServices.isEmpty) {
      return Column(
        children: [
          const _ShimmerDiscoveryCard(),
          const _ShimmerDiscoveryCard(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 8),
              Text(
                'جاري البحث والتعرف التلقائي بالشبكة...',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );
    }

    final isDisconnected = state.connectionState == LanConnectionState.disconnected ||
        state.connectionState == LanConnectionState.error;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.discoveredServices.length,
      itemBuilder: (context, index) {
        final service = state.discoveredServices[index];
        final name = _getTxtValue(service.txt?['deviceName']) ?? service.name ?? 'جهاز كاشير';
        final ip = _getTxtValue(service.txt?['ip']) ?? service.host ?? '0.0.0.0';
        final portStr = _getTxtValue(service.txt?['port']) ?? service.port.toString();

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colors.primary.withValues(alpha: 0.12)),
          ),
          color: colors.primary.withValues(alpha: 0.02),
          child: ListTile(
            leading: Icon(Icons.dns_rounded, color: colors.primary),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('$ip:$portStr', style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisconnected ? colors.primary : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: isDisconnected
                  ? () {
                      final port = int.tryParse(portStr) ?? 8080;
                      ipController.text = ip;
                      portController.text = portStr;
                      context.read<DeviceSettingsBloc>().add(UpdateMasterAddress(ip, port));
                      context.read<DeviceSettingsBloc>().add(ConnectToMasterEvent());
                    }
                  : null,
              child: const Text('ربط سريع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  String? _getTxtValue(dynamic value) {
    if (value == null) return null;
    if (value is Uint8List) {
      return utf8.decode(value);
    }
    if (value is List<int>) {
      return utf8.decode(value);
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}

// Premium pulsing shimmer placeholder for scanning state
class _ShimmerDiscoveryCard extends StatefulWidget {
  const _ShimmerDiscoveryCard();

  @override
  State<_ShimmerDiscoveryCard> createState() => _ShimmerDiscoveryCardState();
}

class _ShimmerDiscoveryCardState extends State<_ShimmerDiscoveryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (_controller.value * 0.4),
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.grey.shade50,
            child: ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              title: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 120,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              subtitle: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 160,
                  height: 8,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              trailing: Container(
                width: 70,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
