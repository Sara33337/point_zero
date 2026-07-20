import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

class AddOrRemove extends StatelessWidget {
  const AddOrRemove({
    super.key,
    required this.onIncrement,
    required this.cartItem,
    required this.onDecrement,
  });

  final VoidCallback onIncrement;
  final CartItemEntity cartItem;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 30.h,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(30.r),
       border: Border.all(color: AppColors.lightGreyColor),
     ),
     child: Center(
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           IconButton(
             onPressed: onIncrement,
             icon: Icon(Icons.add, size: 5.sp),
           ),
           Text(
             "${cartItem.quantity}", 
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 3.sp),
           ),
           IconButton(
             onPressed: onDecrement,
             icon: Icon(Icons.remove, size: 5.sp), // remove شكلها أظبط من minimize
           ),
         ],
       ),
     ),
                  );
  }
}