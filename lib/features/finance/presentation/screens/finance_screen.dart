import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/side_bar.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_state.dart';
import 'package:point_zero/features/finance/presentation/widgets/add_expense.dart';
import 'package:point_zero/features/finance/presentation/widgets/sales_history_tabel.dart';
import 'package:point_zero/features/finance/presentation/widgets/state_card.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SideBar(),
            Expanded(
              child: Padding(
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
                            Text(
                              "شهر ${state.currentMonth} - ${state.currentYear}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.greyColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // كروت الإحصائيات (بتقرأ مباشرة من الـ state)
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
                            SizedBox(width: 16.w),
                            Expanded(
                              child: StatCard(
                                title: "إجمالي المصروفات",
                                amount: state.totalExpense,
                                color: Colors.red.shade700,
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: StatCard(
                                title: "صافي الربح",
                                amount: state.netProfit,
                                color: const Color(0xFF1E1E1E),
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
                              SizedBox(width: 24.w),
                              Expanded(
                                flex: 1,
                                // لو عاملة فورم المصروفات، هيتحط هنا
                                child: const AddExpenseForm(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
