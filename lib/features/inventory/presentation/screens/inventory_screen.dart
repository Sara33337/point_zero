import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/widgets/side_bar.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/features/inventory/presentation/widgets/inventory_header.dart';
import 'package:point_zero/features/inventory/presentation/widgets/product.dart';
import 'package:point_zero/core/widgets/tabel_header.dart';
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

                          TabelHeader(),

                          Expanded(
                            child: ListView.builder(
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                final product = state.products[index];
                                return ProductDetails(product: product);
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
