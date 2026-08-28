import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class BillModel extends BillEntity {
  const BillModel({
    super.id,
    required super.items,
    required super.totalAmount,
    required super.createdAt,
    required super.isExchange,
    super.returnCredit,
    super.returnedProductName,
    super.returnedQuantity
  });

  factory BillModel.fromEntity(BillEntity billEntity) {
    return BillModel(
      id: billEntity.id,
      items: billEntity.items,
      totalAmount: billEntity.totalAmount,
      createdAt: billEntity.createdAt,
      isExchange: billEntity.isExchange,
      returnCredit: billEntity.returnCredit,
      returnedProductName: billEntity.returnedProductName,
      returnedQuantity: billEntity.returnedQuantity
    );
  }

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      totalAmount: map['total_amount'],
      createdAt: DateTime.parse(map['created_at']),
      isExchange: map['is_exchange'] == 1, 
      items: const [],
      returnedProductName: map['returned_product_name'],
      returnedQuantity: map['returned_quantity'],
      returnCredit: map['return_credit'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'is_exchange': isExchange ? 1 : 0, 
    };
  }
}