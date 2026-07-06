import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xfood_pos/core/di/injection.dart';
import 'package:xfood_pos/core/services/device_config_service.dart';
import 'package:xfood_pos/core/services/lan_sync/lan_client_service.dart';
import 'package:xfood_pos/features/settings/presentation/bloc/device_settings_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nsd/nsd.dart' as nsd;

import '../widgets/master_setup_widget.dart';
import '../widgets/client_setup_widget.dart';
import '../widgets/master_active_panel.dart';
import '../widgets/client_active_panel.dart';

/// Screen allowing the cashier/administrator to change the device's role,
/// start the embedded master server, or connect client terminals over the LAN.
class DeviceSettingsPage extends StatelessWidget {
  const DeviceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DeviceSettingsBloc>()..add(LoadDeviceSettings()),
      child: const DeviceSettingsView(),
    );
  }
}

class DeviceSettingsView extends StatefulWidget {
  const DeviceSettingsView({super.key});

  @override
  State<DeviceSettingsView> createState() => _DeviceSettingsViewState();
}

class _DeviceSettingsViewState extends State<DeviceSettingsView> {
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _pinController = TextEditingController();
  
  int _currentStep = 0;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<DeviceSettingsBloc, DeviceSettingsState>(
      listener: (context, state) {
        if (_nameController.text != state.deviceName) {
          _nameController.text = state.deviceName;
        }
        if (_ipController.text != state.masterIp) {
          _ipController.text = state.masterIp;
        }
        if (_portController.text != state.masterPort.toString()) {
          _portController.text = state.masterPort.toString();
        }
        if (_pinController.text != state.pairingPin) {
          _pinController.text = state.pairingPin;
        }

        // Initialize step on first load
        if (!_initialized) {
          _initialized = true;
          if (state.role == DeviceRole.master && state.isServerRunning) {
            _currentStep = 2;
          } else if (state.role != DeviceRole.master && state.connectionState == LanConnectionState.connected) {
            _currentStep = 2;
          }
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.errorMessage!, style: const TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          context.read<DeviceSettingsBloc>().add(ClearMessages());
        }

        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.successMessage!, style: const TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
              backgroundColor: colorScheme.secondary,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          context.read<DeviceSettingsBloc>().add(ClearMessages());
        }
      },
      builder: (context, state) {
        final isMaster = state.role == DeviceRole.master;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'إعدادات الاتصال والمزامنة (LAN Sync)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/pos');
                }
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<DeviceSettingsBloc>().add(LoadDeviceSettings()),
                tooltip: 'تحديث البيانات',
              )
            ],
          ),
          body: Column(
            children: [
              // ── Connection Status Banner ──────────────────────────
              if (!isMaster) _buildConnectionBanner(state, colorScheme),
              
              // ── Stepper Header Indicator ──────────────────────────
              _buildStepperHeader(colorScheme),
              
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                            child: _buildStepContent(context, state, colorScheme),
                          ),
                        ),
                      ),
                    ),
                    if (state.isLoading)
                      Container(
                        color: Colors.black.withValues(alpha: 0.15),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
              
              // ── Bottom Navigation Controls ────────────────────────
              _buildBottomControls(context, state, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepperHeader(ColorScheme colors) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: Row(
        children: [
          _buildStepHeaderCircle(0, 'دور الجهاز', colors),
          _buildStepHeaderLine(0, colors),
          _buildStepHeaderCircle(1, 'البيانات والربط', colors),
          _buildStepHeaderLine(1, colors),
          _buildStepHeaderCircle(2, 'تأكيد الاتصال', colors),
        ],
      ),
    );
  }

  Widget _buildStepHeaderCircle(int step, String label, ColorScheme colors) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDone
                  ? colors.secondary
                  : (isActive ? colors.primary : Colors.grey.shade200),
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [BoxShadow(color: colors.primary.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1)]
                  : null,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? colors.primary
                  : (isDone ? colors.secondary : Colors.grey.shade600),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeaderLine(int step, ColorScheme colors) {
    final isDone = _currentStep > step;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 18),
      color: isDone ? colors.secondary : Colors.grey.shade200,
    );
  }

  Widget _buildStepContent(BuildContext context, DeviceSettingsState state, ColorScheme colors) {
    switch (_currentStep) {
      case 0:
        return Column(
          key: const ValueKey('step_0'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخطوة 1: تحديد دور هذا الجهاز بالشبكة المحلية',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildRoleSelectionGrid(context, state, colors),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'ملاحظة: جهاز الخادم (Master) يجب أن يكون واحداً فقط بالشبكة، وتتصل به باقي أجهزة الخدمة (Clients/KDS).',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 1:
        return Column(
          key: const ValueKey('step_1'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخطوة 2: تهيئة بيانات الاتصال والربط',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildIdentificationCard(context, state, colors),
            const SizedBox(height: 20),
            if (state.role == DeviceRole.master)
              MasterSetupWidget(
                state: state,
                colors: colors,
              )
            else
              ClientSetupWidget(
                state: state,
                colors: colors,
                ipController: _ipController,
                portController: _portController,
                pinController: _pinController,
                onScanQr: () => _openQrScanner(context),
              ),
          ],
        );
      case 2:
      default:
        return Column(
          key: const ValueKey('step_2'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الخطوة 3: تأكيد الاتصال والمتابعة النشطة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (state.role == DeviceRole.master)
              MasterActivePanel(
                state: state,
                colors: colors,
                pairingUri: _buildPairingUri(state),
              )
            else
              ClientActivePanel(
                state: state,
                colors: colors,
                ipController: _ipController,
                portController: _portController,
                onScanQr: () => _openQrScanner(context),
              ),
          ],
        );
    }
  }

  Widget _buildBottomControls(BuildContext context, DeviceSettingsState state, ColorScheme colors) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
              label: const Text('السابق', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
            )
          else
            const SizedBox.shrink(),
          
          if (_currentStep < 2)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              label: const Text('التالي', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _currentStep++;
                });
              },
            )
          else
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.check_circle_rounded),
              label: const Text('إنهاء الإعداد', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                context.go('/pos');
              },
            ),
        ],
      ),
    );
  }

  Widget _buildConnectionBanner(DeviceSettingsState state, ColorScheme colors) {
    Color bannerColor;
    IconData icon;
    String text;
    Widget? trailing;

    switch (state.connectionState) {
      case LanConnectionState.connected:
        bannerColor = colors.secondary;
        icon = Icons.check_circle_rounded;
        text = 'متصل بالخادم الرئيسي (${state.masterIp}:${state.masterPort})';
        break;
      case LanConnectionState.connecting:
        bannerColor = Colors.orange.shade700;
        icon = Icons.sync;
        text = 'جاري محاولة الاتصال بالخادم الرئيسي... (المحاولة ${state.reconnectAttempts})';
        trailing = const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
        break;
      case LanConnectionState.error:
        bannerColor = colors.error;
        icon = Icons.warning_rounded;
        text = 'فشل الاتصال بالخادم الرئيسي. يرجى التحقق من الشبكة وإعدادات الخادم.';
        break;
      case LanConnectionState.disconnected:
      default:
        bannerColor = Colors.grey.shade700;
        icon = Icons.cloud_off_rounded;
        text = 'غير متصل بالخادم الرئيسي حالياً.';
        break;
    }

    return Container(
      width: double.infinity,
      color: bannerColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildRoleSelectionGrid(BuildContext context, DeviceSettingsState state, ColorScheme colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 3 : 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isWide ? 1.4 : 3.8,
          children: [
            _buildRoleOptionCard(
              context: context,
              role: DeviceRole.master,
              currentRole: state.role,
              icon: Icons.dns_rounded,
              title: 'الخادم الرئيسي (Master)',
              desc: 'جهاز الكاشير الأساسي، يشغل الخادم وقاعدة البيانات.',
              colors: colors,
            ),
            _buildRoleOptionCard(
              context: context,
              role: DeviceRole.client,
              currentRole: state.role,
              icon: Icons.tablet_mac_rounded,
              title: 'جهاز فرعي (Client)',
              desc: 'نقطة بيع أو نادل ترسل الطلبات عبر الشبكة.',
              colors: colors,
            ),
            _buildRoleOptionCard(
              context: context,
              role: DeviceRole.kds,
              currentRole: state.role,
              icon: Icons.kitchen_rounded,
              title: 'شاشة المطبخ (KDS)',
              desc: 'شاشة لعرض طلبات التحضير والتجهيز فوراً.',
              colors: colors,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoleOptionCard({
    required BuildContext context,
    required DeviceRole role,
    required DeviceRole currentRole,
    required IconData icon,
    required String title,
    required String desc,
    required ColorScheme colors,
  }) {
    final isSelected = role == currentRole;
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? colors.primaryContainer.withValues(alpha: 0.15) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colors.primary : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.read<DeviceSettingsBloc>().add(UpdateDeviceRole(role));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withValues(alpha: 0.1) : Colors.grey.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? colors.primary : Colors.grey.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? colors.primary : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdentificationCard(BuildContext context, DeviceSettingsState state, ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم تعريف الجهاز بالشبكة',
                hintText: 'مثال: كاشير 1 أو تابلت الصالة',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              onChanged: (val) {
                context.read<DeviceSettingsBloc>().add(UpdateDeviceName(val));
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'رمز الاقتران المشترك (Pairing PIN)',
                hintText: 'أدخل رمزاً للأمان أو اتركه فارغاً',
                prefixIcon: Icon(Icons.security_rounded),
                helperText: 'يجب أن يتطابق الرمز في جميع الأجهزة للاتصال بالخادم الرئيسي.',
              ),
              onChanged: (val) {
                context.read<DeviceSettingsBloc>().add(UpdatePairingPin(val));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openQrScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              AppBar(
                title: const Text('امسح كود QR من الكاشير الرئيسي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(sheetCtx),
                ),
              ),
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final rawValue = barcode.rawValue;
                      if (rawValue != null && rawValue.startsWith('xfood://connect')) {
                        try {
                          final uri = Uri.parse(rawValue);
                          final ip = uri.queryParameters['ip'];
                          final portStr = uri.queryParameters['port'];
                          final pin = uri.queryParameters['pin'];

                          if (ip != null && portStr != null) {
                            final port = int.tryParse(portStr) ?? 8080;

                            _ipController.text = ip;
                            _portController.text = portStr;
                            if (pin != null) {
                              _pinController.text = pin;
                              context.read<DeviceSettingsBloc>().add(UpdatePairingPin(pin));
                            }

                            context.read<DeviceSettingsBloc>().add(UpdateMasterAddress(ip, port));
                            context.read<DeviceSettingsBloc>().add(ConnectToMasterEvent());

                            Navigator.pop(sheetCtx);
                            break;
                          }
                        } catch (_) {}
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildPairingUri(DeviceSettingsState state) {
    final ip = state.serverIp ?? '0.0.0.0';
    final name = Uri.encodeComponent(state.deviceName);
    final pin = Uri.encodeComponent(state.pairingPin);
    return 'xfood://connect?ip=$ip&port=${state.masterPort}&pin=$pin&name=$name';
  }
}
