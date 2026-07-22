import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';
import 'package:point_zero/core/widgets/side_bar.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/inventory/presentation/screens/product_form_dialog.dart';
import 'package:point_zero/features/inventory/presentation/widgets/inventory_header.dart';
import 'package:point_zero/features/inventory/presentation/widgets/product.dart';
import 'package:point_zero/features/inventory/presentation/widgets/tabel_header.dart';
import 'package:point_zero/features/inventory/presentation/widgets/season_toggle_button.dart';


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
                child: BlocBuilder<InventoryCubit, InventoryState>(
                  builder: (context, state) {
                    if (state is InventoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is InventoryLoaded) {
                      return Column(
                        children: [
                          InventoryHeader(),

                          const SizedBox(height: 20),

                          SeasonToggleButtons(
                            selectedFilter: state.selectedFilter,
                            onFilterChanged: (season) {
                              context.read<InventoryCubit>().changeSeasonFilter(
                                season,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          CustomTextFormField(
                            prefixIcon: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              child: SvgPicture.asset(
                                AppIcons.searchIcon,
                                width: 8.w,
                                height: 8.w,
                                color: AppColors.lightGreyColor,
                              ),
                            ),

                            onChanged: (value) {
                              context.read<InventoryCubit>().searchProduct(
                                value,
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          TabelHeader(),

                          Expanded(
                            child: ListView.builder(
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                final product = state.products[index];
                                return ProductDetails(
                                  product: product,
                                  onDelete: () {
                                    _showDeleteDialog(context, product);
                                  },
                                  onEdit: () {
                                    
                                    showDialog(
                                      context: context,
                                      builder: (_) => ProductFormDialog(
                                        productToEdit: product,
                                        onSubmit: (updatedProduct) {
                                          context
                                              .read<InventoryCubit>()
                                              .updateProduct(updatedProduct);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    // حالة الخطأ أو البداية
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _showDeleteDialog(BuildContext context, ProductEntity product) {
    final cubit = context.read<InventoryCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("تأكيد الحذف", textAlign: TextAlign.right),
          content: Text("هل أنت متأكد من حذف المنتج '${product.name}' نهائياً؟", textAlign: TextAlign.right),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                cubit.deleteProduct(product.code); // تنفيذ الحذف
                Navigator.pop(dialogContext); // إغلاق النافذة
              },
              child: const Text("حذف", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

