import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';
import 'package:point_zero/features/pos/presentation/widgets/add_remove_button.dart';
import 'package:point_zero/features/pos/presentation/widgets/unit_price_field.dart';

class ProductOnCart extends StatelessWidget {
  final CartItemEntity cartItem;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Function(String) onPriceChanged;

  const ProductOnCart({
    super.key,
    required this.cartItem,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // شيلنا الارتفاع الثابت واستبدلناه بـ Padding عشان يكون Responsive
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGreyColor),
        color: AppColors.lightFontColor,
        borderRadius: AppStyles.mainBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // غلفنا النص بـ Expanded عشان لو الاسم طويل ميعملش Overflow
              Expanded(
                child: Text(
                  cartItem.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: SvgPicture.asset(AppIcons.deleteIcon),
                constraints:
                    const BoxConstraints(), // لتقليل المساحة الفارغة حول الأيقونة
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          Text(
            cartItem.product.code,
            style: TextStyle(color: Colors.grey, fontSize: 8.sp),
          ),
          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UnitPriceField(
                cartItem: cartItem,
                onPriceChanged: onPriceChanged,
              ),

              AddOrRemove(
                onIncrement: onIncrement,
                cartItem: cartItem,
                onDecrement: onDecrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

