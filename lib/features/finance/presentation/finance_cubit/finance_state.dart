import 'package:equatable/equatable.dart';
import 'package:point_zero/features/finance/domain/entities/expense_entity.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

enum FinanceStatus { initial, loading, loaded, error }

class FinanceState extends Equatable {
  final FinanceStatus status;
  final int currentYear;
  final int currentMonth;
  final List<ExpenseEntity> expenses;
  final List<BillEntity> bills;
  final double totalRevenue;
  final double totalExpense;
  final double netProfit;
  final String error;

  const FinanceState({
    required this.status,
    required this.currentYear,
    required this.currentMonth,
    required this.expenses,
    required this.bills,
    required this.totalRevenue,
    required this.totalExpense,
    required this.netProfit,
    required this.error,
  });

  factory FinanceState.initial() {
    final now = DateTime.now();
    return FinanceState(
      status: FinanceStatus.initial,
      currentMonth: now.month,
      currentYear: now.year,
      bills: const [],
      expenses: const [],
      totalRevenue: 0.0,
      totalExpense: 0.0,
      netProfit: 0.0,
      error: '',
    );
  }

  FinanceState copyWith({
    FinanceStatus? status,
    int? currentMonth,
    int? currentYear,
    List<BillEntity>? bills,
    List<ExpenseEntity>? expenses,
    double? totalRevenue,
    double? totalExpense,
    double? netProfit,
    String? error,
  }) {
    return FinanceState(
      status: status ?? this.status,
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
      bills: bills ?? this.bills,
      expenses: expenses ?? this.expenses,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalExpense: totalExpense ?? this.totalExpense,
      netProfit: netProfit ?? this.netProfit,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentMonth,
    currentYear,
    expenses,
    bills,
    totalRevenue,
    totalExpense,
    netProfit,
    error,
  ];
}
