import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

class UnitPriceField extends StatelessWidget {
  const UnitPriceField({
    super.key,
    required this.cartItem,
    required this.onPriceChanged,
  });

  final CartItemEntity cartItem;
  final Function(String) onPriceChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "\$",
          style: TextStyle(color: Colors.grey, fontSize: 6.sp),
        ),
        SizedBox(width: 4.w),
        SizedBox(
          width: 38.w, // حجم ثابت عشان ميعملش Layout Error
          height: 30.h,
          child: TextFormField(
            initialValue: cartItem.unitPrice.toStringAsFixed(2),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 8.w,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.lightGreyColor),
              ),
            ),
            onChanged: onPriceChanged,
          ),
        ),
      ],
    );
  }
}
