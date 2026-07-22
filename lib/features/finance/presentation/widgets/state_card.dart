import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final Color backGroundColor;
  final Color fontColor;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.backGroundColor = Colors.white,
    this.fontColor = AppColors.primaryColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: AppStyles.mainBorderRadius,
        boxShadow: [
         AppStyles.cardShadow
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 8.sp),
              ),
              SizedBox(width:4.w),
              Text(title, style: AppStyles.smallTitle),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "${amount.toStringAsFixed(2)} ج.م",
            style: AppStyles.largeTitle.copyWith(color: fontColor),
          ),
        ],
      ),
    );
  }
}