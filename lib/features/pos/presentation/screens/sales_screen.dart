import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_state.dart';
import 'package:point_zero/features/pos/presentation/widgets/bill_content.dart';

class SalesScreenForCashier extends StatelessWidget {
  const SalesScreenForCashier({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, FinanceState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    Text("الفواتير السابقة", style: AppStyles.largeTitle),
                    SizedBox(height: 16.h),

                    Expanded(child: BillContent(bills: state.bills)),
                  ],
                ),
              );
            },
          );
       
  }
}
