import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.product,
    required super.quantity,
    required super.unitPrice,
  });

  factory CartItemModel.fromEntity(CartItemEntity cartItem){
   return CartItemModel(
      product: cartItem.product,
      quantity: cartItem.quantity,
      unitPrice: cartItem.unitPrice,
    );
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
  return CartItemModel(
    product: ProductEntity(
      code: map['product_code'],
      name: map['product_name'],
      category: '', 
      season: '',
      wholesalePrice: (map['wholesale_price'] as num).toDouble(),
      sellingPrice: (map['original_price'] ?? map['unit_price'] as num).toDouble(),
      stockQuantity: 0,
    ),
    quantity: map['quantity'] as int,
    unitPrice: (map['unit_price'] as num).toDouble(),
  );
}

  Map<String, dynamic> toMap(int billId) {
    return {
      'bill_id': billId,
      'product_code': product.code,
      'product_name': product.name,
      'quantity': quantity,
      'wholesale_price': product.wholesalePrice,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }
}
