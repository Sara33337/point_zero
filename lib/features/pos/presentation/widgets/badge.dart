import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightFontColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Center(
          child: Text(
            product.category,
            style: AppStyles.smallTitle.copyWith(fontSize: 4.sp, color: AppColors.greyColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
