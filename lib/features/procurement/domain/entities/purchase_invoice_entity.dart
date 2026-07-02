import 'package:equatable/equatable.dart';

class PurchaseInvoiceEntity extends Equatable {
  final int id;
  final String invoiceNumber;
  final String? supplierName;
  final int userId;
  final int? shiftId;
  final double totalAmount;
  final String? notes;
  final String status; // 'completed', 'voided'
  final DateTime createdAt;
  final DateTime updatedAt;

  const PurchaseInvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    this.supplierName,
    required this.userId,
    this.shiftId,
    required this.totalAmount,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isVoided => status == 'voided';

  @override
  List<Object?> get props => [
        id,
        invoiceNumber,
        supplierName,
        userId,
        shiftId,
        totalAmount,
        notes,
        status,
        createdAt,
        updatedAt,
      ];
}
