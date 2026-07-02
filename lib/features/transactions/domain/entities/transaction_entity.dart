import 'package:equatable/equatable.dart';

/// Pure domain entity for a Transaction.
class TransactionEntity extends Equatable {
  final int id;
  final int userId;
  final String type; // sale, purchase, waste, inventoryCheck
  final double totalAmount;
  final String? notes;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.totalAmount,
    this.notes,
    required this.createdAt,
  });

  bool get isSale => type == 'sale';
  bool get isPurchase => type == 'purchase';
  bool get isWaste => type == 'waste';
  bool get isInventoryCheck => type == 'inventoryCheck';

  @override
  List<Object?> get props => [id, userId, type, totalAmount, notes, createdAt];
}
