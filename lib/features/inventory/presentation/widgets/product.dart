import 'package:flutter/material.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(product.name)),
          Expanded(child: Text(product.code)),
          Expanded(child: Text(product.category)),
          Expanded(child: Text("${product.wholesalePrice}")),
          Expanded(child: Text("${product.sellingPrice}")),
          Expanded(child: Text("${product.stockQuantity}")),
        ],
      ),
    );
  }
}
