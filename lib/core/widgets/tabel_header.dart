import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabelHeader extends StatelessWidget {
  const TabelHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      padding: const EdgeInsets.all(12),
      child: const Row(
        children: [
          Expanded(child: Text("اسم المنتج")),
          Expanded(child: Text("الكود")),
          Expanded(child: Text("الفئة")),
          Expanded(child: Text("سعر الجملة")),
          Expanded(child: Text("سعر البيع")),
          Expanded(child: Text("الكمية")),
        ],
      ),
    );
  }
}
