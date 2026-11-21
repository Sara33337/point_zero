import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/finance/presentation/finance_cubit/finance_cubit.dart';
import 'package:point_zero/features/finance/presentation/widgets/edit_sale_item.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class SalesHistoryTable extends StatelessWidget {
  final List<BillEntity> bills;

  const SalesHistoryTable({super.key, required this.bills});

  Future<void> _confirmDeleteItem(
    BuildContext context, {
    required int billItemId,
    required int billId,
    required String productName,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: const Text("تأكيد الحذف"),
        content: Text(
          "هل أنت متأكد من حذف \"$productName\" من سجل المبيعات؟\nسيتم تحديث إجمالي الفاتورة والأرباح تلقائياً.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("تأكيد الحذف"),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<FinanceCubit>().deleteSaleItem(
        billItemId: billItemId,
        billId: billId,
      );
    }
  }

  Future<void> _showEditItemDialog(
    BuildContext context, {
    required int billItemId,
    required int billId,
    required String productName,
    required int currentQty,
    required double currentPrice,
  }) async {
    final result = await EditSaleItemDialog.show(
      context,
      title: "تعديل مبيعة: $productName",
      initialQuantity: currentQty,
      initialPrice: currentPrice,
    );

    if (result != null && context.mounted) {
      context.read<FinanceCubit>().updateSaleItem(
        billItemId: billItemId,
        billId: billId,
        newQuantity: result.quantity,
        newUnitPrice: result.unitPrice,
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> soldItems = [];

    for (var bill in bills) {
      if (bill.isExchange && bill.returnedProductName != null) {
        soldItems.add({
          'billId': bill.id,
          'billItemId': null,
          'date': bill.createdAt,
          'name': bill.returnedProductName,
          'code': '---',
          'originalPrice': 0.0,
          'soldPrice': (bill.returnCredit ?? 0) / (bill.returnedQuantity ?? 1),
          'quantity': bill.returnedQuantity,
          'type': 'returned',
        });
      }

      for (var item in bill.items) {
        soldItems.add({
          'billId': bill.id,
        
          'billItemId': item.billItemId,
          'date': bill.createdAt,
          'name': item.product.name,
          'code': item.product.code,
          'originalPrice': item.product.sellingPrice,
          'soldPrice': item.unitPrice,
          'quantity': item.quantity,
          'type': bill.isExchange ? 'replacement' : 'sale',
        });
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppStyles.mainBorderRadius,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              spacing: 1.w,
              children: [
                Expanded(
                  flex: 2,
                  child: Text("التاريخ", style: AppStyles.headerStyle),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "المنتج",
                    style: AppStyles.headerStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text("الكود", style: AppStyles.headerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text("السعر الأصلي", style: AppStyles.headerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text("سعر البيع", style: AppStyles.headerStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    textAlign: TextAlign.center,
                    "الكمية",
                    style: AppStyles.headerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    textAlign: TextAlign.center,
                    "إجراءات",
                    style: AppStyles.headerStyle,
                  ),
                ),
              ],
            ),
          ),

          // Rows
          Expanded(
            child: soldItems.isEmpty
                ? const Center(child: Text("لا توجد مبيعات في هذا الشهر"))
                : ListView.separated(
                    itemCount: soldItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = soldItems[index];

                      final isDiscounted =
                          item['soldPrice'] < item['originalPrice'] &&
                          item['type'] != 'returned';

                      DateTime dateObj = item['date'] is String
                          ? DateTime.parse(item['date'])
                          : item['date'];

                      String formattedDate = DateFormat(
                        'yyyy/MM/dd hh:mm a',
                      ).format(dateObj);

                      Color badgeColor;
                      String badgeText;
                      if (item['type'] == 'returned') {
                        badgeColor = Colors.red;
                        badgeText = "مرتجع";
                      } else if (item['type'] == 'replacement') {
                        badgeColor = Colors.orange;
                        badgeText = "بديل";
                      } else {
                        badgeColor = Colors.transparent;
                        badgeText = "";
                      }

                      final int? billId = item['billId'] as int?;
                      final int? billItemId = item['billItemId'] as int?;
                      final bool canModify =
                          item['type'] != 'returned' &&
                          billId != null &&
                          billItemId != null;

                      return Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          spacing: 1.w,
                          children: [
                            Expanded(flex: 2, child: Text(formattedDate)),

                            // اسم المنتج + شارة الحالة
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['name'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  if (badgeText.isNotEmpty) ...[
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 1.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        badgeText,
                                        style: TextStyle(
                                          color: badgeColor,
                                          fontSize: 3.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            Expanded(flex: 2, child: Text(item['code'])),

                            Expanded(
                              flex: 2,
                              child: Text(
                                item['type'] == 'returned'
                                    ? "---"
                                    : "${item['originalPrice']} ج.م",
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                "${item['soldPrice']} ج.م",
                                style: TextStyle(
                                  color: isDiscounted
                                      ? Colors.red
                                      : Colors.black,
                                  fontWeight: isDiscounted
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                textAlign: TextAlign.center,
                                item['type'] == 'returned'
                                    ? "+${item['quantity']}"
                                    : "${item['quantity']}",
                                style: TextStyle(
                                  color: item['type'] == 'returned'
                                      ? Colors.green
                                      : Colors.black,
                                  fontWeight: item['type'] == 'returned'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),

                            // عمود الإجراءات (تعديل / حذف)
                            Expanded(
                              flex: 3,
                              child: canModify
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          tooltip: "تعديل",
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.blue.shade700,
                                            size: 6.sp,
                                          ),
                                          onPressed: () => _showEditItemDialog(
                                            context,
                                            billItemId: billItemId,
                                            billId: billId,
                                            productName: item['name'] as String,
                                            currentQty: item['quantity'] as int,
                                            currentPrice:
                                                (item['soldPrice'] as num)
                                                    .toDouble(),
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: "حذف",
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                            color: Colors.red.shade700,
                                            size: 6.sp,
                                          ),
                                          onPressed: () => _confirmDeleteItem(
                                            context,
                                            billItemId: billItemId,
                                            billId: billId,
                                            productName: item['name'] as String,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(child: Text("---")),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}