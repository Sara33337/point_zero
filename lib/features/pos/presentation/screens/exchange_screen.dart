import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_cubit.dart';
import 'package:point_zero/features/pos/presentation/cubit/exchange_cubit/exchange_state.dart';
import 'package:point_zero/features/pos/presentation/widgets/bottom_bar.dart';
import 'package:point_zero/features/pos/presentation/widgets/replacement_section.dart';
import 'package:point_zero/features/pos/presentation/widgets/return_items_section.dart';

class ExchangeDialogWidget extends StatelessWidget {
  const ExchangeDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 900.w, 
          height: 650.h,
          padding: EdgeInsets.all(24.r),
          child: BlocConsumer<ExchangeCubit, ExchangeState>(
            listener: (context, state) {
              if (state.status == ExchangeStatus.success) {
                Navigator.pop(context); // اقفل النافذة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الاستبدال بنجاح!')),
                );
               
              } else if (state.status == ExchangeStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- الهيدر (Header) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.swap_horiz, size: 28),
                          SizedBox(width: 8.w),
                          Text("استبدال منتج", style: AppStyles.largeTitle.copyWith(fontSize: 6.sp)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Text(
                    "ابحث عن الفاتورة القديمة، ثم اختر المنتجات البديلة. لا يوجد استرجاع نقدي لفرق السعر.",
                    style:AppStyles.smallTitle,
                  ),
                  SizedBox(height: 24.h),
        
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العمود الأول: المنتج المُسترجع (Step 1)
                        Expanded(
                          child: ReturnItemsSection(),
                        ),
                        
                        SizedBox(width: 20.w), // مسافة بين العمودين
                        
                        // العمود الثاني: المنتجات البديلة (Step 2)
                        Expanded(
                          child: ReplacementSection(),
                        ),
                      ],
                    ),
                  ),
        
                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 6.h),
        
                  ExchangeBottomBar(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }}