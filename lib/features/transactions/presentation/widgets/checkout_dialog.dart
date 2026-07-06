import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/session_manager.dart';
import '../bloc/pos_bloc.dart';

void showCheckoutDialog(BuildContext parentCtx, double subtotal, {bool isBottomSheet = false}) async {
  final discountController = TextEditingController(text: '0');
  final notesController = TextEditingController();

  final prefs = await SharedPreferences.getInstance();
  final bool isTaxEnabledDefault = prefs.getBool('tax_enabled') ?? true;

  if (!parentCtx.mounted) return;

  showDialog(
    context: parentCtx,
    builder: (dialogCtx) {
      bool isTaxEnabled = isTaxEnabledDefault;
      String selectedPaymentMethod = 'cash';
      String discountType = 'percentage'; // 'percentage' or 'amount'
      double discountInputValue = 0.0;

      return StatefulBuilder(
        builder: (context, setState) {
          double discountPercentage = 0.0;
          double discountValue = 0.0;

          if (discountType == 'percentage') {
            discountPercentage = discountInputValue.clamp(0.0, 100.0);
            discountValue = subtotal * (discountPercentage / 100);
          } else {
            discountValue = discountInputValue.clamp(0.0, subtotal);
            discountPercentage = subtotal > 0 ? (discountValue / subtotal) * 100 : 0.0;
          }

          final netTotal = subtotal - discountValue;
          final taxPercentage = isTaxEnabled ? 14.0 : 0.0;
          final taxValue = netTotal * (taxPercentage / 100);
          final netTotalWithTax = netTotal + taxValue;

          void updateDiscount(double val) {
            setState(() {
              discountInputValue = val;
              discountController.text = val.toStringAsFixed(0);
            });
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'إتمام عملية البيع والخصم والضريبة',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${subtotal.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      const Text('الإجمالي قبل الخصم:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('- ${discountValue.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red)),
                      const Text('قيمة الخصم:', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    title: const Text('تطبيق ضريبة القيمة المضافة (14%)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: isTaxEnabled,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) async {
                      setState(() {
                        isTaxEnabled = val ?? false;
                      });
                      final p = await SharedPreferences.getInstance();
                      await p.setBool('tax_enabled', isTaxEnabled);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  if (isTaxEnabled) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('+ ${taxValue.toStringAsFixed(2)} ج.م', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green)),
                        const Text('الضريبة (14%):', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green)),
                      ],
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${netTotalWithTax.toStringAsFixed(2)} ج.م',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                      const Text('الصافي المستحق:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('طريقة الدفع (Payment Method):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildPaymentMethodButton(
                        context: context,
                        label: 'نقداً (Cash)',
                        icon: Icons.payments_outlined,
                        isSelected: selectedPaymentMethod == 'cash',
                        onTap: () => setState(() => selectedPaymentMethod = 'cash'),
                      ),
                      const SizedBox(width: 8),
                      _buildPaymentMethodButton(
                        context: context,
                        label: 'بطاقة (Card)',
                        icon: Icons.credit_card_outlined,
                        isSelected: selectedPaymentMethod == 'card',
                        onTap: () => setState(() => selectedPaymentMethod = 'card'),
                      ),
                      const SizedBox(width: 8),
                      _buildPaymentMethodButton(
                        context: context,
                        label: 'أونلاين (Online)',
                        icon: Icons.qr_code_scanner_outlined,
                        isSelected: selectedPaymentMethod == 'online',
                        onTap: () => setState(() => selectedPaymentMethod = 'online'),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('نوع الخصم (Discount Type):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                      ToggleButtons(
                        constraints: const BoxConstraints(minHeight: 30, minWidth: 60),
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: Theme.of(context).colorScheme.primary,
                        color: Theme.of(context).colorScheme.onSurface,
                        isSelected: [discountType == 'percentage', discountType == 'amount'],
                        onPressed: (index) {
                          setState(() {
                            discountType = index == 0 ? 'percentage' : 'amount';
                            discountInputValue = 0.0;
                            discountController.clear();
                          });
                        },
                        children: const [
                          Text('%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('ج.م', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: discountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: discountType == 'percentage' ? 'نسبة الخصم (%)' : 'قيمة الخصم (ج.م)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(discountType == 'percentage' ? Icons.percent : Icons.money),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (val) {
                      final parsed = double.tryParse(val) ?? 0.0;
                      setState(() {
                        discountInputValue = parsed;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: discountType == 'percentage'
                        ? [
                            Expanded(child: _buildQuickDiscountButton(context, '5%', () => updateDiscount(5.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '10%', () => updateDiscount(10.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '15%', () => updateDiscount(15.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '20%', () => updateDiscount(20.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, 'إلغاء', () => updateDiscount(0.0), isCancel: true)),
                          ]
                        : [
                            Expanded(child: _buildQuickDiscountButton(context, '10 ج.م', () => updateDiscount(10.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '20 ج.م', () => updateDiscount(20.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '50 ج.م', () => updateDiscount(50.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, '100 ج.م', () => updateDiscount(100.0))),
                            const SizedBox(width: 6),
                            Expanded(child: _buildQuickDiscountButton(context, 'إلغاء', () => updateDiscount(0.0), isCancel: true)),
                          ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: 'ملاحظات إضافية',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final state = parentCtx.read<PosBloc>().state;
                  // Construct customized note indicating fixed discount amount
                  String finalNotes = notesController.text.trim();
                  if (discountType == 'amount' && discountInputValue > 0) {
                    finalNotes = '[FixedDiscount: ${discountInputValue.toStringAsFixed(0)} ج.م]${finalNotes.isNotEmpty ? " $finalNotes" : ""}';
                  }

                  parentCtx.read<PosBloc>().add(
                        CompleteSale(
                          userId: SessionManager.instance.currentUserId,
                          notes: finalNotes.isNotEmpty ? finalNotes : null,
                          discountPercentage: discountPercentage,
                          taxPercentage: taxPercentage,
                          orderType: state.orderType,
                          paymentMethod: selectedPaymentMethod,
                          tableId: state.tableId,
                        ),
                      );
                  Navigator.pop(dialogCtx);
                  if (isBottomSheet) {
                    Navigator.pop(parentCtx);
                  }
                },
                child: const Text('تأكيد ودفع', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildPaymentMethodButton({
  required BuildContext context,
  required String label,
  required IconData icon,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : colors.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : colors.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildQuickDiscountButton(BuildContext context, String label, VoidCallback onPressed, {bool isCancel = false}) {
  final colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    height: 34,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        backgroundColor: isCancel
            ? colorScheme.errorContainer.withValues(alpha: 0.1)
            : colorScheme.primaryContainer.withValues(alpha: 0.1),
        side: BorderSide(
          color: isCancel
              ? colorScheme.error.withValues(alpha: 0.5)
              : colorScheme.primary.withValues(alpha: 0.5),
        ),
        foregroundColor: isCancel ? colorScheme.error : colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isCancel ? colorScheme.error : colorScheme.primary,
        ),
      ),
    ),
  );
}
