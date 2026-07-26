import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalBlock extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  const TotalBlock({super.key, required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 6.sp, color: Colors.grey.shade600)),
        SizedBox(height: 4.h),
        Text(
          "$amount ج.م",
          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

