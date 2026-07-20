import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/finance/domain/useCases/add_expense_useCase.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_expense_data.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_sales_data.dart';

import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final GetMonthlySalesDataUseCase getMonthlySalesUseCase;
  final GetMonthlyExpenseDataUseCase getMonthlyExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;

  FinanceCubit({
    required this.getMonthlySalesUseCase,
    required this.getMonthlyExpensesUseCase,
    required this.addExpenseUseCase,
  }) : super(FinanceState.initial());

  // 1. دالة تحميل بيانات الشهر (مبيعات + مصروفات)
  Future<void> loadMonthlyData({int? month, int? year}) async {
    final targetMonth = month ?? state.currentMonth;
    final targetYear = year ?? state.currentYear;

    emit(
      state.copyWith(
        status: FinanceStatus.loading,
        currentMonth: targetMonth,
        currentYear: targetYear,
        error: '',
      ),
    );

    final salesResult = await getMonthlySalesUseCase(targetMonth, targetYear);
    final expensesResult = await getMonthlyExpensesUseCase(
      targetMonth,
      targetYear,
    );

    salesResult.fold(
      (failure) => emit(
        
        state.copyWith(status: FinanceStatus.error, error: failure.message),
      ),
      (bills) {
        expensesResult.fold(
          (failure) => emit(
            state.copyWith(status: FinanceStatus.error, error: failure.message),
          ),
          (expenses) {
            double revenue = 0.0;
            for (var bill in bills) {
              revenue += bill.totalAmount;
            }
          
            double totalExp = 0.0;
            for (var expense in expenses) {
              totalExp += expense.expenseAmount;
            }

            double profit = revenue - totalExp;
         
            emit(
              state.copyWith(
                status: FinanceStatus.loaded,
                currentMonth: targetMonth,
                currentYear: targetYear,
                bills: bills,
                expenses: expenses,
                totalRevenue: revenue,
                totalExpense: totalExp,
                netProfit: profit,
              ),
            );
          },
        );
      },
    );
  }


  Future<void> addExpense(String name, double amount) async {
    final expense = ExpenseEntity(
      expenseAmount: amount,
      expenseName: name,
      date: DateTime.now(),
    );

    final result = await addExpenseUseCase(expense);

    result.fold(
      (failure) => emit(
        state.copyWith(status: FinanceStatus.error, error: failure.message),
      ),
      (_) async {
        await loadMonthlyData(month: state.currentMonth, year: state.currentYear);
      },
    );
  }

  // 3. دالة تغيير الشهر (لو المدير اختار شهر تاني من الواجهة)
  void changeMonth(int month, int year) {
    loadMonthlyData(month: month, year: year);
  }
}
