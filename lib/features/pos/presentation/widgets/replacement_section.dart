import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/pos/presentation/widgets/selected_exchange_item.dart';

class ReplacementSection extends StatelessWidget {
  const ReplacementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الخطوة 2: المنتجات البديلة", style: AppStyles.smallTitle),
            SizedBox(height: 12.h),

            // 1. حقل البحث (تم التعديل ليكلم ExchangeCubit بدلاً من PosCubit)
            CustomTextFormField(
              hintText: "ابحث باسم أو كود المنتج...",
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                context.read<ExchangeCubit>().searchReplacementProducts(value);
              },
            ),
            SizedBox(height: 12.h),

            // 2. قسم عرض نتائج البحث
            if (state.isSearchingReplacement)
              const Expanded(flex: 3, child: Center(child: CircularProgressIndicator()))
            else if (state.replacementSearchResults.isNotEmpty)
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.replacementSearchResults.length,
                      itemBuilder: (context, index) {
                        final product = state.replacementSearchResults[index];
                        
                        return ListTile(
                          shape: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                          // 👈 التعديل هنا: product.name مباشرة مش product.product.name
                          title: Text(
                            product.name, 
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "كود: ${product.code}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            "${product.sellingPrice} ج.م",
                            style: const TextStyle(
                              color: Colors.green, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // 👈 التعديل هنا: الدالة المسؤولة عن إضافة المنتج للسلة
                            context.read<ExchangeCubit>().addReplacementItem(product);
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            else
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    "ابحث عن منتجات لإضافتها كبديل",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),

            Divider(height: 24.h, thickness: 1.5, color: Colors.grey.shade300),

            // 3. قسم السلة البديلة (المنتجات المختارة)
            Text(
              "السلة البديلة (المنتجات المُختارة):",
              style: AppStyles.mediumFont.copyWith(color: AppColors.primaryColor),
            ),
            SizedBox(height: 8.h),

            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: state.replacementItems.isEmpty
                    ? Center(
                        child: Text(
                          "لم يتم اختيار منتجات بديلة بعد.",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: ListView.builder(
                          padding: EdgeInsets.zero, 
                          itemCount: state.replacementItems.length,
                          itemBuilder: (context, index) {
                            final item = state.replacementItems[index];
                            return SelectedExchangeItem(
                              item: item,
                              onDelete: () => context
                                  .read<ExchangeCubit>()
                                  .removeReplacementItem(item),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}