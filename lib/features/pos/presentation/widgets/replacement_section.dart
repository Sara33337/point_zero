import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/widgets/exchange_item.dart';
import 'package:point_zero/features/pos/presentation/widgets/selected_exchange_item.dart';

class ReplacementSection extends StatelessWidget {
  const ReplacementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("الخطوة 2: المنتجات البديلة", style: AppStyles.smallTitle),
        SizedBox(height: 12.h),

        CustomTextFormField(
          hintText: "ابحث باسم أو كود المنتج...",
          prefixIcon: const Icon(Icons.search),
          onChanged: (value) {
            context.read<PosCubit>().searchProduct(value);
          },
        ),
        SizedBox(height: 12.h),

        // 2. لستة المنتجات المتاحة (المخزن)
        Expanded(
          flex: 3,
          child: ClipRect(
            child: BlocBuilder<PosCubit, PosState>(
              builder: (context, posState) {
                if (posState.filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "لا يوجد منتجات متاحة.",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: posState.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = posState.filteredProducts[index];
                    return ExchangeItem(product: product);
                  },
                );
              },
            ),
          ),
        ),

        Divider(height: 24.h, thickness: 1.5, color: Colors.grey.shade300),
        SizedBox(
          child: Text(
            "السلة البديلة (المنتجات المُختارة):",
            style: AppStyles.mediumFont.copyWith(color: AppColors.primaryColor),
          ),
        ),

        SizedBox(height: 8.h),
        Expanded(
          flex: 2,
          child: ClipRect(
            child: BlocBuilder<ExchangeCubit, ExchangeState>(
              builder: (context, state) {
                if (state.replacementItems.isEmpty) {
                  return Center(
                    child: Text(
                      "لم يتم اختيار منتجات بديلة بعد.",
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),

                  child: ClipRect(
                    child: ListView.builder(
                      padding: EdgeInsets.zero, // 👈 تصفير البادينج
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
