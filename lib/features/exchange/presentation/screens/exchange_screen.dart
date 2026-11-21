import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/invoice_printer.dart';
import 'package:point_zero/features/exchange/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/exchange/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/exchange/presentation/widgets/bottom_bar.dart';
import 'package:point_zero/features/exchange/presentation/widgets/replacement_section.dart';
import 'package:point_zero/features/exchange/presentation/widgets/return_items_section.dart';

class ExchangeDialogWidget extends StatelessWidget {
  const ExchangeDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 900.w,
          height: 650.h,
          padding: EdgeInsets.all(24.r),
          child: BlocConsumer<ExchangeCubit, ExchangeState>(
            listener: (context, state) async {
              if (state.status == ExchangeStatus.success) {
                bool printFailed = false;
                try {
                  await InvoicePrinter.printExchangeReceipt(
                    returnedItem: state.returnedItem!,
                    returnQuantity: state.returnQuantity,
                    replacementItems: state.replacementItems,
                    returnCredit: state.returnCredit,
                    replacementTotal: state.replacementTotal,
                    differencePaid: state.customerPays,
              
                  );
                } catch (_) {
                  printFailed = true;
                }

                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      printFailed
                          ? 'تم الاستبدال بنجاح، ولكن تعذرت طباعة الإيصال.'
                          : 'تم الاستبدال بنجاح!',
                    ),
                  ),
                );
              } else if (state.status == ExchangeStatus.error &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              } else if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.swap_horiz, size: 28),
                          SizedBox(width: 8.w),
                          Text(
                            "استبدال منتج",
                            style: AppStyles.largeTitle.copyWith(fontSize: 8.sp),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: state.status == ExchangeStatus.loading
                            ? null
                            : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(
                    "ابحث عن الفاتورة القديمة أو كود المنتج، ثم اختر المنتجات البديلة. لا يوجد استرجاع نقدي لفرق السعر.",
                    style: AppStyles.smallTitle,
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(child: ReturnItemsSection()),
                        SizedBox(width: 20.w),
                        const Expanded(child: ReplacementSection()),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 6.h),
                  const ExchangeBottomBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}