import 'package:equatable/equatable.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

class BillEntity extends Equatable {
  final int? id;
  final List<CartItemEntity> items;
  final double totalAmount;
  final DateTime createdAt;
  final bool isExchange;
  final String? returnedProductName;
  final int? returnedQuantity;
  final double? returnCredit;
  final double? returnedWholesaleCost;

  const BillEntity({
    this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.isExchange,
    this.returnedProductName,
    this.returnedQuantity,
    this.returnCredit,
    this.returnedWholesaleCost,
  });

  BillEntity copyWith({
    int? id,
    List<CartItemEntity>? items,
    double? totalAmount,
    DateTime? createdAt,
    bool? isExchange,
    String? returnedProductName,
    int? returnedQuantity,
    double? returnCredit,
    double? returnedWholesaleCost,
  }) {
    return BillEntity(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      isExchange: isExchange ?? this.isExchange,
      returnedProductName: returnedProductName ?? this.returnedProductName,
      returnedQuantity: returnedQuantity ?? this.returnedQuantity,
      returnCredit: returnCredit ?? this.returnCredit,
      returnedWholesaleCost:
          returnedWholesaleCost ?? this.returnedWholesaleCost,
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    totalAmount,
    createdAt,
    isExchange,
    returnedProductName,
    returnCredit,
    returnedQuantity,
    returnedWholesaleCost,
  ];
}