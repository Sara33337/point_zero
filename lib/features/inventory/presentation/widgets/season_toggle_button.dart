import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';

class SeasonToggleButtons extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const SeasonToggleButtons({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['الكل', 'صيفي', 'شتوي'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;
        return GestureDetector(
          onTap: () => onFilterChanged(filter),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondaryColor : Colors.transparent,
              borderRadius: AppStyles.mainBorderRadius,
              border: Border.all(
                color: isSelected ? AppColors.secondaryColor : AppColors.greyColor,
              ),
            ),
            child: Text(
              filter,
              style: TextStyle(
                color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}