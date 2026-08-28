import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/invoice_printer.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';


class BillContent extends StatelessWidget {
  final List<BillEntity> bills;

  const BillContent({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      return const Center(child: Text("لا توجد فواتير سابقة"));
    }
    final reversedBills = bills.reversed.toList();
    return ListView.builder(
      itemCount: reversedBills.length,
      itemBuilder: (context, index) {
        final bill = reversedBills[index];
        final formattedDate = DateFormat(
          'yyyy-MM-dd  hh:mm a',
        ).format(bill.createdAt);

        return Container(
          margin: EdgeInsets.all(12.r),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGreyColor),
            borderRadius: AppStyles.mainBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("فاتورة #${bill.id}", style: AppStyles.largeTitle),
                  Text(formattedDate, style: AppStyles.smallTitle),
                  Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          // لو استبدال لونها برتقالي، لو بيع لونها أخضر
                          color: bill.isExchange ? Colors.orange.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          bill.isExchange ? "استبدال" : "بيع",
                          style: TextStyle(
                            color: bill.isExchange ? Colors.orange.shade800 : Colors.green.shade800,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                ],
              ),

              Divider(height: 20.h),
              ...bill.items.map((cartItem) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartItem.product.name,
                        style: AppStyles.mediumFont.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        cartItem.unitPrice.toString(),
                        style: AppStyles.mediumFont,
                      ),
                      Text(cartItem.product.code, style: AppStyles.mediumFont),
                      Text(
                        'الكمية: ${cartItem.quantity}',
                        style: AppStyles.mediumFont,
                      ),
                    ],
                  ),
                );
              }),

              Divider(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "الإجمالي: ${bill.totalAmount} جنيه",
                    style: AppStyles.largeTitle.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),

                  SizedBox(
                    width: 90.w,
                    child: PrimaryButton(
                      buttonText: "طباعة",
                      onTap: () async {
                        if (bill.isExchange && bill.returnedProductName != null) {
                          // 1. حساب إجمالي البدائل
                          double replacementTotal = 0;
                          for (var item in bill.items) {
                            replacementTotal += (item.unitPrice * item.quantity);
                          }

                          // 2. عمل كائن وهمي للمرتجع عشان نبعته لدالة الطباعة بتاعتك
                          final dummyReturnedItem = PastSaleItemEntity(
                            billId: 0,
                            productCode: '',
                            productName: bill.returnedProductName!,
                            unitPrice: 0,
                            quantity: bill.returnedQuantity!,
                            createdAt: DateTime.now(),
                          );

                          // 3. طباعة إيصال الاستبدال كاملاً
                          await InvoicePrinter.printExchangeReceipt(
                            returnedItem: dummyReturnedItem,
                            returnQuantity: bill.returnedQuantity!,
                            replacementItems: bill.items.map((e) => e as CartItemModel).toList(),
                            returnCredit: bill.returnCredit!,
                            replacementTotal: replacementTotal,
                            differencePaid: bill.totalAmount,
                          );
                        } else {
                          // طباعة فاتورة بيع عادية
                          await InvoicePrinter.printReceipt(bill);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
