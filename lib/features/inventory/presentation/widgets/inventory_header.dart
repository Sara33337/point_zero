import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/inventory/presentation/screens/product_form_dialog.dart';

class InventoryHeader extends StatelessWidget {
  const InventoryHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("المخزن", style: AppStyles.largeTitle),
            BlocBuilder<InventoryCubit, InventoryState>(
              builder: (context, state) {
                if (state is InventoryLoaded) {
                  final productCount = state.products.length;
    
                  // final categoryCount = state.products
                  //     .map((e) => e.category)
                  //     .toSet()
                  //     .length;
    
                  final totalProductStock = state.products
                      .fold<int>(
                        0,
                        (sum, product) =>
                            sum + product.stockQuantity,
                      );
    
                  final totalProductsWholeSalePeice = state
                      .products
                      .fold<double>(
                        0,
                        (sum, product) =>
                            sum +
                            (product.stockQuantity *
                                product.wholesalePrice),
                      );
    
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                      "يوجد في المخزن $productCount منتجات",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 5.sp,
                        ),
                      ),
    
                      Text(
                        "يوجد في المخزن $totalProductStock قطعة | بسعر جملة $totalProductsWholeSalePeice ج.م",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 5.sp,
                        ),
                      ),
                    ],
                  );
                }
    
                return const Text("لايوجد منتجات حاليا في المخزن");
              },
            ),
          ],
        ),
        PrimaryButton(
          onTap: () {
            final inventoryCubit = context
                .read<InventoryCubit>();
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: inventoryCubit,
                child: ProductFormDialog(
                  onSubmit: (newpProduct) {
                    context.read<InventoryCubit>().addProduct(
                      newpProduct,
                    );
                  },
                ),
              ),
            );
          },
          buttonText: "إضافة منتج جديد",
        ),
      ],
    );
  }
}
