import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:point_zero/core/theme/app_icons.dart';
import 'package:point_zero/features/pos/data/models/cart_item_model.dart';

class SelectedExchangeItem extends StatelessWidget {
  const SelectedExchangeItem({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
    required this.onPriceChanged,
  });

  final CartItemModel item;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<double> onPriceChanged;

  void _showEditPriceDialog(BuildContext context) {
    final controller = TextEditingController(
      text: item.unitPrice.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تعديل سعر: ${item.product.name}'),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'السعر الجديد (ج.م)',
                  suffixText: 'ج.م',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال السعر';
                  }
                  final parsed = double.tryParse(value.trim());
                  if (parsed == null || parsed < 0) {
                    return 'أدخل رقماً صحيحاً أكبر من أو يساوي صفر';
                  }
                  return null;
                },
                onFieldSubmitted: (_) =>
                    _submitPrice(dialogContext, formKey, controller),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _submitPrice(dialogContext, formKey, controller),
                child: const Text('حفظ'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitPrice(
    BuildContext dialogContext,
    GlobalKey<FormState> formKey,
    TextEditingController controller,
  ) {
    if (!formKey.currentState!.validate()) return;
    final newPrice = double.parse(controller.text.trim());
    Navigator.pop(dialogContext);
    onPriceChanged(newPrice);
  }

  @override
  Widget build(BuildContext context) {
    final totalItemPrice = item.unitPrice * item.quantity;

    return ListTile(
      title: Text(
        item.product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 18),
            onPressed: onDecrement,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("الكمية: ${item.quantity}"),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 18),
            onPressed: onIncrement,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _showEditPriceDialog(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit, size: 15, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  "سعر الوحدة: ${item.unitPrice.toStringAsFixed(2)} ج.م",
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${totalItemPrice.toStringAsFixed(2)} ج.م",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: SvgPicture.asset(AppIcons.deleteIcon),
          ),
        ],
      ),
    );
  }
}