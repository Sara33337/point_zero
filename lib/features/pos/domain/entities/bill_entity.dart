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
