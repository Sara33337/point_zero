import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class Category extends StatelessWidget {
  final String categoryName;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const Category({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 1.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),

          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 7.w,
                height: 7.w,
                color: isSelected
                    ? AppColors.lightFontColor
                    : AppColors.lightGreyColor,
              ),
              SizedBox(width: 3.w),
              Text(
                categoryName,
                style: AppStyles.categoryFont.copyWith(
                  color: isSelected
                      ? AppColors.lightFontColor
                      : AppColors.lightGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
