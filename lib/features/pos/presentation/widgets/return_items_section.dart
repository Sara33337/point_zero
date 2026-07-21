import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/pos/presentation/widgets/return_item.dart';

class ReturnItemsSection extends StatelessWidget {
  const ReturnItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الخطوة 1: المنتج المُسترجع", style: AppStyles.smallTitle),
            SizedBox(height: 12.h),
            CustomTextFormField(
              hintText: "ابحث بكود المنتج...",
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                context.read<ExchangeCubit>().searchPastBills(value);
              },
            ),

            SizedBox(height: 16.h),

            if (state.isSearching)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (state.searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: state.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = state.searchResults[index];
          
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      
                        title: Text(result.productName),
                        subtitle: Text(
                          "كود: ${result.productCode} | رقم الفاتورة : ${result.billId}",
                        ),
                        trailing: Text("${result.unitPrice} ج.م"),
                        onTap: () {
                          context.read<ExchangeCubit>().selectReturnedItem(
                            result,
                            
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            // 3. عرض المنتج المُسترجع بعد اختياره بنجاح
            else if (state.returnedItem != null)
              ReturnItem()
            else
              Expanded(
                child: Center(
                  child: Text(
                    "لم يتم تحديد منتج مرتجع",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

