import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';

class ExpenseHistoryTable extends StatelessWidget {
  final List<ExpenseEntity> expenses;
  const ExpenseHistoryTable({super.key , required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.mainBorderRadius,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              spacing: 1.w,
              children: [
                Expanded(child: Text("التاريخ", style: AppStyles.headerStyle)),
               
                Expanded(child: Text("بند المصروف", style: AppStyles.headerStyle)),
                Expanded(
                  child: Text("المبلغ", style: AppStyles.headerStyle),
                ),
              ],
            ),
          ),

       
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text("لا توجد مصروفات في هذا الشهر"))
                : ListView.separated(
                    itemCount: expenses.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                
                      String formattedDate = DateFormat(
                        'yyyy/MM/dd hh:mm a',
                      ).format(expense.date);

                      return Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          spacing: 1.w,
                          children: [
                            Expanded(child: Text(formattedDate)),
                            Expanded(child: Text(expense.expenseName)),
                            Expanded(child: Text(expense.expenseAmount.toString())),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );;
  }
}