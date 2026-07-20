import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class Category extends StatelessWidget {
  final String categoryName;
  final String icon;
  final bool isSelected = false;
  final VoidCallback onTap;

   const Category({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap : onTap,
      child: Container(
        color: isSelected ? AppColors.secondaryColor : Colors.transparent,

        child: Padding(
          padding: EdgeInsets.all(9.r),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 8.w,
                height: 8.w,
                color: AppColors.secondaryColor,
              ),
              SizedBox(width: 2.w),
              Text(categoryName, style: AppStyles.categoryFont),
            ],
          ),
        ),
      ),
    );
  }
}
