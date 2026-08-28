import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/theme/app_styles.dart';
import 'package:point_zero/core/utils/invoice_printer.dart';
import 'package:point_zero/core/widgets/custom_drop_down_menu.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:point_zero/features/inventory/domain/entites/product_entity.dart';
import 'package:point_zero/features/inventory/presentation/inventory_cubit/inventory_cubit.dart';
import 'package:point_zero/core/widgets/custom_text_field.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductEntity? productToEdit; 
  final Function(ProductEntity product) onSubmit;

  const ProductFormDialog({
    super.key, 
    this.productToEdit, 
    required this.onSubmit,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final productNameController = TextEditingController();
  final productCodeController = TextEditingController();
  final wholesalePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedSeason;
  final List<String> seasons = ['صيفي', 'شتوي'];
  bool get isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    
    if (isEditing) {
      final p = widget.productToEdit!;
      productNameController.text = p.name;
      productCodeController.text = p.code;
      wholesalePriceController.text = p.wholesalePrice.toString();
      sellingPriceController.text = p.sellingPrice.toString();
      stockQuantityController.text = p.stockQuantity.toString();
      categoryController.text = p.category;
      selectedSeason = p.season;
    } else {
   
      _initializeAutoCode();
    }
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
                  // 👈 3. تغيير العنوان ديناميكياً
                  Text(
                    isEditing ? "تعديل المنتج" : "إضافة منتج جديد", 
                    style: AppStyles.largeTitle
                  ),

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
                    readOnly: true, // الكود مبيتعدلش في الحالتين
                  ),

                  CustomDropDownMenu(
                    selectedItem: selectedSeason,
                    items: seasons,
                    onChanged: (value) {
                      setState(() {
                        selectedSeason = value;
                      });
                    },
                    labelText: "الموسم",
                  ),

                  CustomTextFormField(
                    controller: wholesalePriceController,
                    labelText: "سعر الجملة:",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "أدخل سعر الجملة";
                      if (double.tryParse(value) == null) return "أدخل رقم صحيح";
                      return null;
                    },
                  ),

                  CustomTextFormField(
                    controller: sellingPriceController,
                    labelText: "سعر البيع:",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "أدخل سعر البيع";
                      if (double.tryParse(value) == null) return "أدخل رقم صحيح";
                      return null;
                    },
                  ),


                  CustomTextFormField(
                    controller: stockQuantityController,
                    labelText: "الكمية :",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "أدخل الكمية";
                      if (int.tryParse(value) == null) return "أدخل رقم صحيح";
                      return null;
                    },
                  ),

                  PrimaryButton(
                    buttonText: isEditing ? "حفظ التعديلات" : "إضافة",
                    onTap: () async { // 👈 خليناها async
                      if (!_formKey.currentState!.validate()) return;
                      if (selectedSeason == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('برجاء اختيار الموسم')),
                        );
                        return;
                      }
                      
                      final product = ProductEntity(
                        id: isEditing ? widget.productToEdit!.id : 0, 
                        code: productCodeController.text,
                        name: productNameController.text,
                        category: categoryController.text,
                        season: selectedSeason!,
                        wholesalePrice: double.tryParse(wholesalePriceController.text) ?? 0.0,
                        sellingPrice: double.tryParse(sellingPriceController.text) ?? 0.0,
                        stockQuantity: int.tryParse(stockQuantityController.text) ?? 0,
                      );

                      // 1. احفظ المنتج في الداتابيز
                      widget.onSubmit(product);

                      // 2. اسأل المدير: تطبع استيكرات؟ (بنعرض Dialog تأكيدي سريع)
                      final bool? shouldPrint = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text("تم الحفظ بنجاح", textAlign: TextAlign.center),
                            content: const Text(
                              "هل تريد طباعة ملصقات الباركود (Stickers) لهذا المنتج؟",
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            actions: [
                              TextButton(
                                child: const Text("لا"),
                                onPressed: () => Navigator.pop(dialogContext, false),
                              ),
                              ElevatedButton(
                                child: const Text("نعم، اطبع"),
                                onPressed: () => Navigator.pop(dialogContext, true),
                              ),
                            ],
                          );
                        },
                      );

                    
                      if (shouldPrint == true) {
                        await InvoicePrinter.printProductStickers(
                          productName: product.name,
                          productCode: product.code,
                          sellingPrice: product.sellingPrice,
                          quantity: product.stockQuantity, // بيطبع بعدد الكمية المتاحة
                        );
                      }

                      // 4. نقفل الفورم الأساسية بعد ما نخلص خالص
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
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