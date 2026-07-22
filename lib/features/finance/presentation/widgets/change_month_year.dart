import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/show_month_year_picker.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_state.dart';

class ChangeMonthYear extends StatelessWidget {
  const ChangeMonthYear({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, state) {
        return InkWell(
          onTap: () => showMonthYearPicker(context, state),
          borderRadius: AppStyles.mainBorderRadius,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: AppStyles.mainBorderRadius,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.primaryColor),
                SizedBox(width: 2.w),
                Text(
                  "شهر ${state.currentMonth} - ${state.currentYear}",
                  style: AppStyles.smallTitle,
                ),
                SizedBox(width: 2.w),
                Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
              ],
            ),
          ),
        );
      },
    );
  }
}
