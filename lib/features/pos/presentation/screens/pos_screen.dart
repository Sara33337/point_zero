import 'package:flutter/material.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/widgets/side_bar.dart';
import 'package:point_zero/features/pos/presentation/widgets/bill_body.dart';
import 'package:point_zero/features/pos/presentation/widgets/pos_body.dart';


class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SideBar(),

            const PosBody(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: VerticalDivider(),
            ),

            const BillBody(),
          ],
        ),
      ),
    );
  }
}




