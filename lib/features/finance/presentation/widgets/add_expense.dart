import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({super.key});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();

  @override
  void dispose() {
    expenseNameController.dispose();
    expenseAmountController.dispose();
    super.dispose();
  }

  void _submitExpense() {
    // 1. تصليح قراءة اسم المصروف
    final expenseName = expenseNameController.text.trim();
    final expenseAmount = double.tryParse(expenseAmountController.text) ?? 0;

    if (expenseName.isNotEmpty && expenseAmount > 0) {
      // 2. تصليح طريقة استدعاء الـ read
      context.read<FinanceCubit>().addExpense(expenseName, expenseAmount);
      
      // 3. تفريغ الحقلين بشكل صحيح
      expenseNameController.clear();
      expenseAmountController.clear();

      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.mainBorderRadius,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "إضافة مصروف ",
         
            style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),

          CustomTextFormField(
            controller: expenseNameController,
            labelText: "اسم المصروف (مثال: فواتير)",
          ),
          SizedBox(height: 14.h),

          CustomTextFormField(
            controller: expenseAmountController,
            labelText: "المبلغ",
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 18.h),

          PrimaryButton(buttonText: "حفظ المصروف", onTap: _submitExpense),
        ],
      ),
    );
  }
}