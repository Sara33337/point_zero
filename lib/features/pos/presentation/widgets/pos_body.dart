import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/widgets/product_for_chashier.dart';

class PosBody extends StatelessWidget {
  const PosBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            CustomTextFormField(
              prefixIcon: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 6.w , vertical: 4.h),
                child: SvgPicture.asset(
                  AppIcons.searchIcon,
                  width: 8.w,
                  height: 8.w,
                  color: AppColors.lightGreyColor,
                ),
              ),
    
              onChanged: (value) {
                context.read<PosCubit>().searchProduct(value);
              },
            ),
            SizedBox(height: 16.h),
    
            BlocBuilder<PosCubit, PosState>(
              builder: (context, state) {
                if (state.status == PosStatus.loading) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
    
                if (state.status == PosStatus.error) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
    
                if (state.status == PosStatus.loaded ||
                    state.status == PosStatus.checkoutSuccess) {
                  if (state.filteredProducts.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text("لا توجد منتجات مطابقة للبحث"),
                      ),
                    );
                  }
    
                  return Expanded(
                    child: GridView.builder(
                      itemCount: state.filteredProducts.length,
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 7.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 0.8.r,
                          ),
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductForCashier(
                          product: product,
                          onTap: () => context
                              .read<PosCubit>()
                              .addToCart(product),
                        );
                      },
                    ),
                  );
                }
                return const Expanded(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}