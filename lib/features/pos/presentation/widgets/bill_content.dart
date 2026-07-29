import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/invoice_printer.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class BillContent extends StatelessWidget {
  final List<BillEntity> bills;

  const BillContent({super.key, required this.bills});

  @override
  Widget build(BuildContext context) {
    if (bills.isEmpty) {
      return const Center(child: Text("لا توجد فواتير سابقة"));
    }

    return ListView.builder(
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
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
                        await InvoicePrinter.printReceipt(bill);
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
