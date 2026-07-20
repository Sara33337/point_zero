
import 'package:equatable/equatable.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final double unitPrice;

  const CartItemEntity({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  CartItemEntity copyWith({
    int? quantity,
    double? unitPrice,
  }) {
    return CartItemEntity(
      product: product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [product, quantity, unitPrice];
}
