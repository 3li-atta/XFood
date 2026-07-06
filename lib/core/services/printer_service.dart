import 'dart:convert';
import '../../database/app_database.dart';

class PrinterService {
  PrinterService._();
  static final PrinterService instance = PrinterService._();

  /// Generate ESC/POS bytes for receipt printing and kick out the cash drawer
  List<int> generateReceiptBytes({
    required Transaction transaction,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required String cashierName,
    bool kickDrawer = true,
  }) {
    final List<int> bytes = [];

    // 1. Kick cash drawer command (ESC p m t1 t2)
    // ESC = 0x1B, p = 0x70, m = 0 (pin 2) or 1 (pin 5), t1 = 25, t2 = 250
    if (kickDrawer) {
      bytes.addAll([0x1B, 0x70, 0x00, 0x19, 0xFA]);
    }

    // Initialize printer (ESC @)
    bytes.addAll([0x1B, 0x40]);

    // Align Center (ESC a 1)
    bytes.addAll([0x1B, 0x61, 0x01]);

    // Double size text (GS ! 0x11)
    bytes.addAll([0x1D, 0x21, 0x11]);
    bytes.addAll(utf8.encode("مطعم XFood\n"));

    // Normal size text (GS ! 0x00)
    bytes.addAll([0x1D, 0x21, 0x00]);
    bytes.addAll(utf8.encode("فرع القاهرة الرئيسي\n"));
    bytes.addAll(utf8.encode("الرقم الضريبي: 123-456-789\n"));
    bytes.addAll(utf8.encode("هاتف: 01000000000\n"));
    bytes.addAll(utf8.encode("================================\n"));

    // Align Left (ESC a 0)
    bytes.addAll([0x1B, 0x61, 0x00]);
    bytes.addAll(utf8.encode("رقم الفاتورة: #${transaction.id}\n"));
    bytes.addAll(utf8.encode("تاريخ الفاتورة: ${transaction.createdAt.toString()}\n"));
    bytes.addAll(utf8.encode("نوع الطلب: ${transaction.orderType == 'dine_in' ? 'محلي' : transaction.orderType == 'takeaway' ? 'سفري' : 'توصيل'}\n"));
    if (transaction.tableId != null) {
      bytes.addAll(utf8.encode("رقم الطاولة: الطاولة ${transaction.tableId}\n"));
    }
    bytes.addAll(utf8.encode("الكاشير: $cashierName\n"));
    bytes.addAll(utf8.encode("--------------------------------\n"));

    // Items list
    bytes.addAll(utf8.encode("الصنف            | الكمية | الإجمالي\n"));
    bytes.addAll(utf8.encode("--------------------------------\n"));
    for (final item in items) {
      final name = item['meal_name'] as String;
      final qty = item['quantity'] as double;
      final price = item['meal_price'] as double;
      final itemTotal = qty * price;
      
      // Basic padding to align columns
      final namePadded = name.padRight(16).substring(0, 16);
      final qtyString = qty.toStringAsFixed(0).padLeft(5);
      final totalString = itemTotal.toStringAsFixed(2).padLeft(8);
      bytes.addAll(utf8.encode("$namePadded | $qtyString | $totalString\n"));
    }
    bytes.addAll(utf8.encode("================================\n"));

    // Totals
    bytes.addAll(utf8.encode("الإجمالي قبل الخصم: ${subtotal.toStringAsFixed(2)} ج.م\n"));
    bytes.addAll(utf8.encode("قيمة الخصم: -${discount.toStringAsFixed(2)} ج.م\n"));
    bytes.addAll(utf8.encode("الضريبة (14%): +${tax.toStringAsFixed(2)} ج.م\n"));
    bytes.addAll(utf8.encode("--------------------------------\n"));
    
    // Double size grand total
    bytes.addAll([0x1D, 0x21, 0x11]);
    bytes.addAll(utf8.encode("الصافي المستحق: ${total.toStringAsFixed(2)} ج.م\n"));
    bytes.addAll([0x1D, 0x21, 0x00]);
    
    bytes.addAll(utf8.encode("================================\n"));
    bytes.addAll([0x1B, 0x61, 0x01]); // Align center
    bytes.addAll(utf8.encode("شكراً لزيارتكم!\n\n\n"));

    // Cut paper command (GS V 66 0)
    bytes.addAll([0x1D, 0x56, 0x42, 0x00]);

    return bytes;
  }
}
