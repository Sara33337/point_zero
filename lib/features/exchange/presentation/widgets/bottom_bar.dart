import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/exchange/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/exchange/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/exchange/presentation/widgets/total_block.dart';

class ExchangeBottomBar extends StatelessWidget {
  const ExchangeBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        final isLoading = state.status == ExchangeStatus.loading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TotalBlock(
                  label: "رصيد المرتجع",
                  amount: state.returnCredit,
                  color: Colors.orange,
                ),
                SizedBox(width: 12.w),
                TotalBlock(
                  label: "إجمالي البديل",
                  amount: state.replacementTotal,
                  color: Colors.black,
                ),
                SizedBox(width: 12.w),
                TotalBlock(
                  label: state.customerPays > 0 ? "المطلوب دفعه" : "الرصيد متزن",
                  amount: state.customerPays,
                  color: state.customerPays > 0 ? Colors.black : Colors.green,
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(width: 16.w),
                isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : PrimaryButton(
                        buttonText: "تأكيد الاستبدال",
                        onTap: () =>
                            context.read<ExchangeCubit>().submitExchange(),
                      ),
              ],
            ),
          ],
        );
      },
    );
  }
}