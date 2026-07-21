import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_state.dart';

class ReturnItem extends StatelessWidget {
  const ReturnItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        if (state.returnedItem == null) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange.shade200),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.orange.shade50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.returnedItem!.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (state.billId != null)

                  Text(
                    "${state.returnedItem!.productCode} | رقم الفاتورة : ${state.billId}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              Text(
                "\$${state.returnedItem!.unitPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              
              // جمعنا زراير الكمية في Row عشان الشكل ميبقاش منعكش
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      final currentQty = state.returnQuantity;
                      context.read<ExchangeCubit>().updateReturnQuantity(
                        currentQty - 1,
                        state.maxReturnQuantity, // 2. بنبعت الحد الأقصى الثابت
                      );
                    },
                  ),
                  
                  // 3. كبرنا الخط عشان الكاشير يشوفه بوضوح
                  Text(
                    '${state.returnQuantity}',
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                  
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      final currentQty = state.returnQuantity;
                      context.read<ExchangeCubit>().updateReturnQuantity(
                        currentQty + 1,
                        state.maxReturnQuantity, // 2. بنبعت الحد الأقصى الثابت
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}