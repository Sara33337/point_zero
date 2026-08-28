import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/widgets/product_for_chashier.dart';

// 👈 1. حولناها لـ StatefulWidget عشان نتحكم في الـ Focus والـ Controller
class PosBody extends StatefulWidget {
  const PosBody({super.key});

  @override
  State<PosBody> createState() => _PosBodyState();
}

class _PosBodyState extends State<PosBody> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onBarcodeScanned(String scannedCode) {
    if (scannedCode.trim().isEmpty) return;

    final cubit = context.read<PosCubit>();
    final state = cubit.state;

    try {
      final product = state.allProducts.firstWhere(
        (p) => p.code == scannedCode.trim(),
      );

      cubit.addToCart(product);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لم يتم العثور على منتج بكود: $scannedCode'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    _searchController.clear();
    cubit.searchProduct(''); 
    _focusNode.requestFocus(); 
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              hintText: "ابحث بالاسم أو اضرب الباركود...",
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
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
         
              onFieldSubmitted: (value) {
                _onBarcodeScanned(value);
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

                if (state.status == PosStatus.loaded || state.status == PosStatus.checkoutSuccess) {
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 7.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.8.r,
                      ),
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductForCashier(
                          product: product,
                          onTap: () => context.read<PosCubit>().addToCart(product),
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