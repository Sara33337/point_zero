import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

class SelectedExchangeItem extends StatelessWidget {
  const SelectedExchangeItem({
    super.key,
    required this.item,
    required this.onDelete
  });

  final CartItemModel item;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("الكمية: ${item.quantity}"),
      trailing: Column(
        children: [
          Text(
            "\$${(item.unitPrice * item.quantity).toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: onDelete,
            child: SvgPicture.asset(AppIcons.deleteIcon))
        ],
      ),
    );
  }
}
