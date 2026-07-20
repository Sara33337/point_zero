import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';

class AddProductDialog extends StatefulWidget {
  final Function(ProductEntity product) onAdd;

  const AddProductDialog({super.key, required this.onAdd});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final productNameController = TextEditingController();
  final productCodeController = TextEditingController();
  final wholesalePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameController.dispose();
    productCodeController.dispose();
    wholesalePriceController.dispose();
    sellingPriceController.dispose();
    stockQuantityController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeAutoCode();
  }

  Future<void> _initializeAutoCode() async {
    try {
      final code = await context.read<InventoryCubit>().getNewProductCode();
      if (!mounted) return;
      if (code != null) {
        setState(() {
          productCodeController.text = code;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),

        child: Padding(
          padding: EdgeInsets.all(18.r),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20.h,

                children: [
                  Text("إضافة منتج جديد", style: AppStyles.largeTitle),

                  CustomTextFormField(
                    controller: productNameController,
                    labelText: "اسم المنتج:",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "من فضلك أدخل اسم المنتج";
                      }
                      return null;
                    },
                  ),

                  CustomTextFormField(
                    controller: productCodeController,
                    labelText: "كود المنتج:",
                    readOnly: true,
                  ),

                  CustomTextFormField(
                    controller: wholesalePriceController,
                    labelText: "سعر الجملة:",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "أدخل سعر الجملة";
                      }

                      if (double.tryParse(value) == null) {
                        return "أدخل رقم صحيح";
                      }

                      return null;
                    },
                  ),

                  CustomTextFormField(
                    controller: sellingPriceController,
                    labelText: "سعر البيع:",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "أدخل سعر البيع";
                      }

                      if (double.tryParse(value) == null) {
                        return "أدخل رقم صحيح";
                      }

                      return null;
                    },
                  ),

                  CustomTextFormField(
                    controller: categoryController,
                    labelText: "الفئة :",
                  ),

                  CustomTextFormField(
                    controller: stockQuantityController,
                    labelText: "الكمية :",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "أدخل الكمية";
                      }

                      if (int.tryParse(value) == null) {
                        return "أدخل رقم صحيح";
                      }

                      return null;
                    },
                  ),

                  PrimaryButton(
                    buttonText: "إضافة",

                    onTap: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final product = ProductEntity(
                        code: productCodeController.text,
                        name: productNameController.text,
                        category: categoryController.text,
                        wholesalePrice:
                            double.tryParse(wholesalePriceController.text) ??
                            0.0,
                        sellingPrice:
                            double.tryParse(sellingPriceController.text) ?? 0.0,
                        stockQuantity:
                            int.tryParse(stockQuantityController.text) ?? 0,
                      );

                      widget.onAdd(product);

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
