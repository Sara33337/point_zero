import 'package:flutter/material.dart';
import 'package:point_zero/features/pos/presentation/widgets/bill_body.dart';
import 'package:point_zero/features/pos/presentation/widgets/pos_body.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PosBody(),
        Padding(padding: const EdgeInsets.all(8.0), child: VerticalDivider()),
        const BillBody(),
      ],
    );
  }
}
