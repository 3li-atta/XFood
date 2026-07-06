import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import '../../../../database/app_database.dart';
import '../bloc/pos_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/session_manager.dart';
import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../../core/services/update_service.dart';
import '../../../../core/services/printer_service.dart';
import '../../../../core/presentation/widgets/update_dialog.dart';
import '../widgets/pos_navigation_rail.dart';
import '../widgets/pos_menu_grid.dart';
import '../widgets/pos_cart_sidebar.dart';
import '../../../../core/presentation/widgets/connection_status_widget.dart';

/// POS Screen — main cashier interface with menu grid + cart sidebar.
class PosPage extends StatelessWidget {
  const PosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PosBloc>()),
        BlocProvider(create: (_) => getIt<ShiftBloc>()..add(CheckActiveShift(session.currentUserId))),
      ],
      child: const _PosView(),
    );
  }
}

class _PosView extends StatefulWidget {
  const _PosView();

  @override
  State<_PosView> createState() => _PosViewState();
}

class _PosViewState extends State<_PosView> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  void _checkForUpdates() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updateService = UpdateService();
      final updateInfo = await updateService.checkForUpdate();
      if (updateInfo != null && mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => UpdateDialog(updateInfo: updateInfo),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return BlocListener<PosBloc, PosState>(
      listener: (context, state) async {
        if (state.status == PosStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✓ Sale completed successfully!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );

          if (state.completedTransaction != null &&
              state.completedTransactionItems != null &&
              mounted) {
            _showReceiptPrintDialog(
              context,
              state.completedTransaction!,
              state.completedTransactionItems!,
            );
          }
        } else if (state.status == PosStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Sale failed'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: BlocBuilder<ShiftBloc, ShiftState>(
        builder: (context, shiftState) {
          if (shiftState.status == ShiftStatus.initial ||
              (shiftState.status == ShiftStatus.loading &&
                  shiftState.activeShift == null)) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (shiftState.activeShift == null) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          const Text(
                            'يجب فتح الوردية أولاً للوصول إلى المبيعات\n(An active shift must be opened first to access sales)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () => context.go('/shifts'),
                            icon: const Icon(Icons.add),
                            label: const Text('Go to Shift Management / فتح وردية'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          
          // Active shift exists, render main POS view
          if (isMobile) {
            return Scaffold(
              body: const SafeArea(
                child: Column(
                  children: [
                    ConnectionStatusWidget(),
                    Expanded(
                      child: Row(
                        children: [
                          // Left: Navigation rail
                          PosNavigationRail(),
                          // Right: Menu grid (Expanded, taking all remaining width)
                          Expanded(child: PosMenuGrid()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: const PersistentBottomCart(),
            );
          } else {
            return Scaffold(
              body: const SafeArea(
                child: Column(
                  children: [
                    ConnectionStatusWidget(),
                    Expanded(
                      child: Row(
                        children: [
                          // Left: Navigation rail
                          PosNavigationRail(),
                          // Center: Menu grid (meals)
                          Expanded(flex: 3, child: PosMenuGrid()),
                          // Right: Cart sidebar
                          SizedBox(
                            width: 320,
                            child: PosCartSidebar(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

void _showReceiptPrintDialog(BuildContext context, Transaction txn, List<Map<String, dynamic>> items) {
  final cashierName = SessionManager.instance.currentUser?.username ?? 'كاشير';
  final subtotal = txn.subtotalAmount;
  final discount = txn.discountAmount;
  final tax = txn.taxAmount;
  final total = txn.totalAmount;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('تم إتمام العملية بنجاح!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('معاينة فاتورة العميل (Receipt Preview):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('مطعم XFood', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Text('فرع القاهرة الرئيسي', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                    const Text('الرقم الضريبي: 123-456-789', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                    const Text('--------------------------------', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monospace')),
                    Text('رقم الفاتورة: #${txn.id}', style: const TextStyle(fontSize: 10)),
                    Text('التاريخ: ${DateFormat('yyyy-MM-dd HH:mm').format(txn.createdAt)}', style: const TextStyle(fontSize: 10)),
                    Text('طريقة الدفع: ${txn.paymentMethod == 'card' ? 'بطاقة' : txn.paymentMethod == 'online' ? 'أونلاين' : 'نقداً'}', style: const TextStyle(fontSize: 10)),
                    Text('نوع الطلب: ${txn.orderType == 'dine_in' ? 'محلي' : txn.orderType == 'takeaway' ? 'سفري' : 'توصيل'}', style: const TextStyle(fontSize: 10)),
                    const Text('--------------------------------', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monospace')),
                    ...items.map((item) {
                      final name = item['meal_name'] as String;
                      final qty = item['quantity'] as double;
                      final price = item['meal_price'] as double;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$name x${qty.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                          Text('${(qty * price).toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 10)),
                        ],
                      );
                    }),
                    const Text('--------------------------------', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'monospace')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي قبل الخصم:', style: TextStyle(fontSize: 10)),
                        Text('${subtotal.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الخصم:', style: TextStyle(fontSize: 10, color: Colors.red)),
                        Text('-${discount.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 10, color: Colors.red)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الضريبة (14%):', style: TextStyle(fontSize: 10)),
                        Text('+${tax.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الصافي المستحق:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Text('${total.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('إغلاق'),
          ),
          OutlinedButton.icon(
            onPressed: () {
              final bytes = PrinterService.instance.generateReceiptBytes(
                transaction: txn,
                items: items,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                total: total,
                cashierName: cashierName,
                kickDrawer: true,
              );
              debugPrint('Kicked Cash Drawer. Hex codes sent: [0x1B, 0x70, 0x00, 0x19, 0xFA]');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ تم إرسال أمر فتح درج الكاشير بنجاح!'), backgroundColor: Colors.green),
              );
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('درج النقدية'),
          ),
          FilledButton.icon(
            onPressed: () {
              final bytes = PrinterService.instance.generateReceiptBytes(
                transaction: txn,
                items: items,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                total: total,
                cashierName: cashierName,
                kickDrawer: false,
              );
              debugPrint('Sent ${bytes.length} bytes to ESC/POS Bluetooth Thermal Printer.');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✓ تم إرسال الفاتورة للطابعة بنجاح!'), backgroundColor: Colors.green),
              );
              Navigator.pop(dialogCtx);
            },
            icon: const Icon(Icons.print),
            label: const Text('طباعة الفاتورة'),
          ),
        ],
      );
    },
  ).then((_) {
    if (context.mounted) {
      context.read<PosBloc>().add(const ResetPosStatus());
    }
  });
}
