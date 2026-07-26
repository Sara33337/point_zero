import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  });

  final ProductEntity product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(product.name)),
          Expanded(child: Text(product.code)),
          Expanded(child: Text(product.season)),
          Expanded(child: Text("${product.wholesalePrice}")),
          Expanded(child: Text("${product.sellingPrice}")),
          Expanded(child: Text("${product.stockQuantity}")),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                spacing: 4.w,
                children: [
                  InkWell(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      AppIcons.deleteIcon,
                      width: 16.w,
                      height: 16.h,
                      color: AppColors.redColor,
                    ),
                  ),
                  InkWell(
                    onTap: onEdit,
                    child: SvgPicture.asset(
                      AppIcons.editIcon,
                      width: 16.w,
                      height: 16.h,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
