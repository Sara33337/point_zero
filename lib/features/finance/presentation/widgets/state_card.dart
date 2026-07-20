import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
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
            style: AppStyles.largeTitle,
          ),
        ],
      ),
    );
  }
}