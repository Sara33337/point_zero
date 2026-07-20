import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/core/widgets/side_bar.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/inventory/presentation/screens/add_new_product.dart';
import 'package:point_zero/features/inventory/presentation/widgets/product.dart';
import 'package:point_zero/core/widgets/tabel_header.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(40.r),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("المخزن", style: AppStyles.largeTitle),
                            BlocBuilder<InventoryCubit, InventoryState>(
                              builder: (context, state) {
                                if (state is InventoryLoaded) {
                                  final productCount = state.products.length;
                                  final categoryCount = state.products
                                      .map((e) => e.category)
                                      .toSet()
                                      .length;

                                  return Text(
                                    "$productCount منتجات خلال $categoryCount فئات",
                                    style: TextStyle(
                                      color: AppColors.greyColor,
                                      fontSize: 5.sp,
                                    ),
                                  );
                                }

                                return const Text("0 منتج خلال 0 فئات");
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
                                child: AddProductDialog(
                                  onAdd: (product) {
                                    context.read<InventoryCubit>().addProduct(
                                      product,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          buttonText: "إضافة منتج جديد",
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    TabelHeader(),

                    Expanded(
                      child: BlocBuilder<InventoryCubit, InventoryState>(
                        builder: (context, state) {
                          if (state is InventoryLoaded) {
                            return ListView.builder(
                              itemCount: state.products.length,

                              itemBuilder: (context, index) {
                                final product = state.products[index];

                                return ProductDetails(product: product);
                              },
                            );
                          }

                          if (state is InventoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
