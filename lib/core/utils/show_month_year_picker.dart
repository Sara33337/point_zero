import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/core/widgets/secondary_button.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_state.dart';

void showMonthYearPicker(BuildContext context, FinanceState state) {
  int selectedMonth = state.currentMonth;
  int selectedYear = state.currentYear;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (stateContext, setState) {
          return AlertDialog(
            title: const Text("اختر الشهر والسنة", textAlign: TextAlign.center),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text("شهر ${index + 1}"),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedMonth = value);
                  },
                ),

                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(10, (index) {
                    int year = DateTime.now().year - index;
                    return DropdownMenuItem(value: year, child: Text("$year"));
                  }),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedYear = value);
                  },
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              SecondaryButton(
                buttonText: "إالغاء",
                onTap: () => Navigator.pop(dialogContext),
              ),
              SizedBox(height: 8.h,),
              PrimaryButton(
                onTap: () {
                  context.read<FinanceCubit>().changeMonth(
                    selectedMonth,
                    selectedYear,
                  );
                  Navigator.pop(dialogContext);
                },
                buttonText: "عرض البيانات",
              ),
            ],
          );
        },
      );
    },
  );
}
