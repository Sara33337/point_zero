import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';

class AppStyles {
  static TextStyle brandName = TextStyle(
    color: AppColors.lightFontColor,
    fontWeight: FontWeight.bold,
    fontSize: 7.sp,
    letterSpacing: 1.8,
  );
  static TextStyle categoryFont = TextStyle(
    fontSize: 4.5.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.lightFontColor,
  );

  static TextStyle smallTitle = TextStyle(
    fontSize: 4.5.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.greyColor,
  );

  static TextStyle largeTitle = TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryColor,
  );

  static TextStyle buttonText = TextStyle(
    fontSize: 5.sp,
    color: AppColors.lightFontColor,
  );

  static TextStyle mediumFont = TextStyle(
    fontSize: 6.sp,
    color: AppColors.greyColor,
  );

  static TextStyle headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
    fontSize: 4.sp,
  );

  static TextStyle copyRights = TextStyle(
    fontWeight: FontWeight.w800,
    color: AppColors.lightGreyColor,
    fontSize: 3.sp,
  );

  static BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BorderRadius mainBorderRadius = BorderRadius.circular(20.r);

}
