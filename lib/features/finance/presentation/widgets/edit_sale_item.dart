import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_colors.dart';

class EditSaleItemResult {
  final int quantity;
  final double unitPrice;

  const EditSaleItemResult({
    required this.quantity,
    required this.unitPrice,
  });
}

class EditSaleItemDialog extends StatefulWidget {
  final String title;
  final int initialQuantity;
  final double initialPrice;
  final String quantityLabel;
  final String priceLabel;
  final String confirmText;
  final String cancelText;

  const EditSaleItemDialog({
    super.key,
    required this.title,
    required this.initialQuantity,
    required this.initialPrice,
    this.quantityLabel = "الكمية",
    this.priceLabel = "سعر البيع (ج.م)",
    this.confirmText = "حفظ التعديل",
    this.cancelText = "إلغاء",
  });

  static Future<EditSaleItemResult?> show(
    BuildContext context, {
    required String title,
    required int initialQuantity,
    required double initialPrice,
    String quantityLabel = "الكمية",
    String priceLabel = "سعر البيع (ج.م)",
    String confirmText = "حفظ التعديل",
    String cancelText = "إلغاء",
  }) {
    return showDialog<EditSaleItemResult>(
      context: context,
      builder: (_) => EditSaleItemDialog(
        title: title,
        initialQuantity: initialQuantity,
        initialPrice: initialPrice,
        quantityLabel: quantityLabel,
        priceLabel: priceLabel,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  @override
  State<EditSaleItemDialog> createState() => _EditSaleItemDialogState();
}

class _EditSaleItemDialogState extends State<EditSaleItemDialog> {
  late final TextEditingController _qtyController;
  late final TextEditingController _priceController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(
      text: widget.initialQuantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.initialPrice.toString(),
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSave() {
    final newQty = int.tryParse(_qtyController.text.trim()) ?? 0;
    final newPrice = double.tryParse(_priceController.text.trim()) ?? -1;

    if (newQty <= 0 || newPrice < 0) {
      setState(() {
        _errorText = "أدخل كمية أكبر من 0 وسعراً صحيحاً";
      });
      return;
    }

    Navigator.of(context).pop(
      EditSaleItemResult(quantity: newQty, unitPrice: newPrice),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
      
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        title: Text(widget.title),
        content: SizedBox(
          width: 140.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: widget.quantityLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: widget.priceLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              if (_errorText != null) ...[
                SizedBox(height: 8.h),
                Text(
                  _errorText!,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 4.sp),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.lightFontColor,
            ),
            onPressed: _onSave,
            child: Text(widget.confirmText),
          ),
        ],
      ),
    );
  }
}