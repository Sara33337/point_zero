import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/pos/presentation/widgets/badge.dart';

class ProductForCashier extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;
  const ProductForCashier({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.lightGreyColor),
          borderRadius: AppStyles.mainBorderRadius,
          boxShadow: [AppStyles.cardShadow],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6.h,
          children: [
            CustomBadge(product: product),
            SizedBox(height: 4.h),
            Text(
              product.code,
              style: AppStyles.smallTitle.copyWith(
                fontSize: 4.sp,
                color: AppColors.primaryColor,
              ),
            ),
            Text(
              product.name,
              style: AppStyles.smallTitle.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Text(
              "${product.sellingPrice.toString()} جنيه",
              style: AppStyles.largeTitle.copyWith(
                fontSize: 5.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: Center(
                child: Icon(Icons.add, color: AppColors.lightFontColor , size: 6.sp,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
