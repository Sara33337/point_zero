import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/finance/domain/useCases/add_expense_useCase.dart';
import 'package:point_zero/features/finance/domain/useCases/delete_expense_use_case.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_expense_data.dart';
import 'package:point_zero/features/finance/domain/useCases/get_monthly_sales_data.dart';
import 'package:point_zero/features/finance/domain/useCases/update_expense_use_case.dart';

import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final GetMonthlySalesDataUseCase getMonthlySalesUseCase;
  final GetMonthlyExpenseDataUseCase getMonthlyExpensesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final UpdateBillItemUseCase updateBillItemUseCase;
  final DeleteBillItemUseCase deleteBillItemUseCase;

  FinanceCubit({
    required this.getMonthlySalesUseCase,
    required this.getMonthlyExpensesUseCase,
    required this.addExpenseUseCase,
    required this.updateBillItemUseCase,
    required this.deleteBillItemUseCase,
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

    // بنجيب الداتا من الداتابيز
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
            // 1. إجمالي المبيعات (مجموع الفواتير كما هي)
            double grossSales = 0.0;
            // 2. إجمالي تكلفة الجملة للبضاعة المباعة
            double totalWholesaleCost = 0.0;

            for (var bill in bills) {
              grossSales += bill.totalAmount;

              for (var item in bill.items) {
                totalWholesaleCost += (item.product.wholesalePrice * item.quantity);
              }

              if (bill.isExchange && bill.returnedWholesaleCost != null) {
                totalWholesaleCost -= bill.returnedWholesaleCost!;
              }
            }

            // 3. إجمالي المصروفات
            double totalExp = 0.0;
            for (var expense in expenses) {
              totalExp += expense.expenseAmount;
            }

            // 4. القيم النهائية:
            // إجمالي الإيرادات = مجموع أسعار البيع بدون خصم المصروفات
            double revenue = grossSales;

            // مكسب البضاعة = المبيعات - تكلفة الجملة
            double grossProfit = grossSales - totalWholesaleCost;

            // صافي الربح = مكسب البضاعة - إجمالي المصروفات
            double profit = grossProfit - totalExp;

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

  // 2. دالة إضافة مصروف جديد
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

  Future<void> deleteSaleItem({
    required int billItemId,
    required int billId,
  }) async {
    final result = await deleteBillItemUseCase(
      billItemId: billItemId,
      billId: billId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: FinanceStatus.error, error: failure.message),
      ),
      (_) async {
        await loadMonthlyData(
          month: state.currentMonth,
          year: state.currentYear,
        );
      },
    );
  }

  Future<void> updateSaleItem({
    required int billItemId,
    required int billId,
    required int newQuantity,
    required double newUnitPrice,
  }) async {
    final result = await updateBillItemUseCase(
      billItemId: billItemId,
      billId: billId,
      newQuantity: newQuantity,
      newUnitPrice: newUnitPrice,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: FinanceStatus.error, error: failure.message),
      ),
      (_) async {
        await loadMonthlyData(
          month: state.currentMonth,
          year: state.currentYear,
        );
      },
    );
  }

  // 3. دالة تغيير الشهر (لو المدير اختار شهر تاني من الواجهة)
  void changeMonth(int month, int year) {
    loadMonthlyData(month: month, year: year);
  }
}
