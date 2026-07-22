import 'package:flutter/material.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/widgets/side_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SideBar(),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}