import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';

class ExchangeItem extends StatelessWidget {
  const ExchangeItem({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = product.stockQuantity <= 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h), 
      child: ListTile(
        tileColor: isOutOfStock ? Colors.grey.shade100 : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: isOutOfStock ? Colors.grey.shade300 : Colors.blue.shade100),
          borderRadius: AppStyles.mainBorderRadius,
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isOutOfStock ? Colors.grey.shade500 : Colors.black,
            decoration: isOutOfStock ? TextDecoration.lineThrough : null, // شطب خفيف لو خلصان
          ),
        ),
        subtitle: Text(
          "كود: ${product.code} | المتاح: ${product.stockQuantity}",
          style: TextStyle(
            color: isOutOfStock ? Colors.red.shade300 : Colors.grey.shade600,
          ),
        ),
        trailing: Text(
          "\$${product.sellingPrice}", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isOutOfStock ? Colors.grey.shade500 : Colors.green.shade700,
          ),
        ),
        onTap: isOutOfStock 
            ? null 
            : () {
                final cartItem = CartItemModel(
                  product: product,
                  quantity: 1, 
                  unitPrice: product.sellingPrice,
                );
                context.read<ExchangeCubit>().addReplacementItem(cartItem);
              },
      ),
    );
  }
}