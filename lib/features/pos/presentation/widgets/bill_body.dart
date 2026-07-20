import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/exchange_dialog.dart';
import 'package:point_zero/core/utils/invoice_printer.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/core/widgets/secondary_button.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';
import 'package:point_zero/features/pos/presentation/cubit/pos_cubit/pos_cubit.dart';
import 'package:point_zero/features/pos/presentation/widgets/product_on_cart.dart';

class BillBody extends StatelessWidget {
  const BillBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
              
                    Text(
                       "الفاتورة الحالية",
                      style: AppStyles.largeTitle,
                    ),
                SizedBox(height: 16.h),

                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.h,
                        ), // مسافة بين المنتجات
                        child: ProductOnCart(
                          cartItem: cartItem,

                          onDelete: () => context
                              .read<PosCubit>()
                              .decrementQuantity(cartItem.product),
                          onIncrement: () => context.read<PosCubit>().addToCart(
                            cartItem.product,
                          ),
                          onDecrement: () => context
                              .read<PosCubit>()
                              .decrementQuantity(cartItem.product),
                          onPriceChanged: (value) {
                            final newPrice = double.tryParse(value);
                            if (newPrice != null) {
                              context.read<PosCubit>().updateUnitPrice(
                                cartItem.product,
                                newPrice,
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("الإجمالي:", style: AppStyles.smallTitle),
                    Text(
                      "\$${state.totalAmount.toStringAsFixed(2)}",
                      style: AppStyles.largeTitle,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                

                PrimaryButton(
                  buttonText: "دفع",
                  onTap: () async {
                    if (state.cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("السلة فارغة، أضف منتجات أولاً"),
                        ),
                      );
                      return;
                    }

                    final currentBill = BillEntity(
                      id: DateTime.now().millisecondsSinceEpoch,
                      items: List.from(state.cartItems),
                      totalAmount: state.totalAmount,
                      createdAt: DateTime.now(),
                    );

                    context.read<PosCubit>().checkout();
                    await InvoicePrinter.printReceipt(currentBill);
                  },
                ),
                
                SizedBox(height: 6.h,),
                SecondaryButton(buttonText: 
                "استبدال", onTap: () => showExchangeDialog(context))

              ],
            ),
          ),
        );
      },
    );
  }
}
