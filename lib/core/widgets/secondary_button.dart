import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const SecondaryButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.w),
        height: 40.h,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primaryColor,)
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
