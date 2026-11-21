
import 'package:equatable/equatable.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class CartItemEntity extends Equatable {
  final ProductEntity product;
  final int quantity;
  final double unitPrice;
  final int? billItemId;

  const CartItemEntity({
    required this.product,
    required this.quantity,
    required this.unitPrice, this.billItemId,
  });

  double get subtotal => quantity * unitPrice;

  CartItemEntity copyWith({
    int? billItemId,
    int? quantity,
    double? unitPrice,
  }) {
    return CartItemEntity(
      product: product,
      billItemId: billItemId ?? this.billItemId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [product, quantity, unitPrice];
}
