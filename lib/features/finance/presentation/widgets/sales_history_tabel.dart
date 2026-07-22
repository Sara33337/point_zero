import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class SalesHistoryTable extends StatelessWidget {
  final List<BillEntity> bills;

  const SalesHistoryTable({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> soldItems = [];
    for (var bill in bills) {
      for (var item in bill.items) {
        soldItems.add({
          'date': bill.createdAt,
          'name': item.product.name,
          'code': item.product.code,
          'originalPrice': item.product.sellingPrice,
          'soldPrice': item.unitPrice,
          'quantity': item.quantity,
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
                Expanded(
                  child: Text(
                    "المنتج",
                    style: AppStyles.headerStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(child: Text("الكود", style: AppStyles.headerStyle)),
                Expanded(
                  child: Text("السعر الأصلي", style: AppStyles.headerStyle),
                ),
                Expanded(
                  child: Text("سعر البيع", style: AppStyles.headerStyle),
                ),
                Expanded(child: Text("الكمية", style: AppStyles.headerStyle)),
              ],
            ),
          ),

          // سطور البيانات
          Expanded(
            child: soldItems.isEmpty
                ? const Center(child: Text("لا توجد مبيعات في هذا الشهر"))
                : ListView.separated(
                    itemCount: soldItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = soldItems[index];
                      // تلوين سعر البيع لو فيه خصم
                      final isDiscounted =
                          item['soldPrice'] < item['originalPrice'];
                      DateTime dateObj = item['date'] is String
                          ? DateTime.parse(item['date'])
                          : item['date'];

                      String formattedDate = DateFormat(
                        'yyyy/MM/dd hh:mm a',
                      ).format(dateObj);

                      return Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          spacing: 1.w,
                          children: [
                            Expanded(child: Text(formattedDate)),
                            Expanded(child: Text(item['name'])),
                            Expanded(child: Text(item['code'])),
                            Expanded(child: Text("\$${item['originalPrice']}")),
                            Expanded(
                              child: Text(
                                "\$${item['soldPrice']}",
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
                            Expanded(child: Text("${item['quantity']}")),
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
