import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_state.dart';
import 'package:point_zero/features/finance/presentation/widgets/add_expense.dart';
import 'package:point_zero/features/finance/presentation/widgets/change_month_year.dart';
import 'package:point_zero/features/finance/presentation/widgets/expense_history_table.dart';
import 'package:point_zero/features/finance/presentation/widgets/sales_history_tabel.dart';
import 'package:point_zero/features/finance/presentation/widgets/state_card.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
                padding: EdgeInsets.all(30.r),
                child: BlocBuilder<FinanceCubit, FinanceState>(
                  builder: (context, state) {
                    if (state.status == FinanceStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // 2. عرض الشاشة الطبيعي (حتى لو بنعمل تحميل لشهر جديد، الداتا القديمة هتفضل ظاهرة)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "الأرباح والمصروفات",
                              style: AppStyles.largeTitle,
                            ),
                            ChangeMonthYear(),
                            // Text(
                            //   "شهر ${state.currentMonth} - ${state.currentYear}",
                            //   style: AppStyles.largeTitle,
                            // ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: "إجمالي الإيرادات",
                                amount: state.totalRevenue,
                                color: Colors.green.shade700,
                                icon: Icons.arrow_upward_rounded,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: StatCard(
                                title: "إجمالي المصروفات",
                                amount: state.totalExpense,
                                color: Colors.red.shade700,
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: StatCard(
                                backGroundColor: AppColors.primaryColor,
                                fontColor: AppColors.secondaryColor,
                                title: "صافي الربح",
                                amount: state.netProfit,
                                color: AppColors.lightGreyColor,
                                icon: Icons.account_balance_wallet_rounded,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: SalesHistoryTable(bills: state.bills),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(flex: 2, child: Column(
                                children: [
                                  const AddExpenseForm(),
                                  const SizedBox(height: 4,),
                                  Expanded(child: ExpenseHistoryTable(expenses: state.expenses))
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );    
  }
}

