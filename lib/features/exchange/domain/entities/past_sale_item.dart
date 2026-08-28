import 'package:equatable/equatable.dart';

class PastSaleItemEntity extends Equatable {
  final int billId;
  final String productCode;
  final String productName;
  final double unitPrice;
  final int quantity;
  final DateTime createdAt;

  const PastSaleItemEntity({
    required this.billId,
    required this.productCode,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.createdAt,
  });

  PastSaleItemEntity copyWith({
    int? billId,
    String? productCode,
    String? productName,
    int? quantity,
    DateTime? createdAt,
  }) {
    return PastSaleItemEntity(
      billId: billId ?? this.billId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    billId,
    productCode,
    productName,
    unitPrice,
    quantity,
    createdAt,
  ];
}
