import 'package:point_zero/features/pos/domain/entities/past_sale_item.dart';

class PastSaleItemModel extends PastSaleItemEntity {
  const PastSaleItemModel({
    required super.billId,
    required super.productCode,
    required super.productName,
    required super.unitPrice,
    required super.quantity,
    required super.createdAt,
  });

  factory PastSaleItemModel.fromMap(Map<String, dynamic> map) {
    return PastSaleItemModel(
      billId: map['bill_id'] as int,
      productCode: map['product_code'] as String,
      productName: map['product_name'] as String,
      unitPrice: (map['unit_price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}