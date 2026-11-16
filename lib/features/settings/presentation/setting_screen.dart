import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:point_zero/core/widgets/primary_button.dart';
import 'package:printing/printing.dart';
import 'package:point_zero/core/theme/app_colors.dart';
import 'package:point_zero/core/utils/printer_prefs.dart'; // مسار ملف الـ Prefs اللي عملناه

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Printer> _printers = [];
  bool _isLoading = true;
  
  String? _selectedReceiptPrinter;
  String? _selectedStickerPrinter;

  @override
  void initState() {
    super.initState();
    _loadPrintersAndSettings();
  }

  Future<void> _loadPrintersAndSettings() async {
    try {
      // 1. جلب الطابعات المتصلة بالكمبيوتر
      final printers = await Printing.listPrinters();
      
      // 2. جلب الإعدادات المحفوظة مسبقاً
      final savedReceipt = await PrinterPrefs.getReceiptPrinter();
      final savedSticker = await PrinterPrefs.getStickerPrinter();

      setState(() {
        _printers = printers;
        
        // التحقق من أن الطابعة المحفوظة موجودة ضمن الطابعات المتاحة حالياً
        _selectedReceiptPrinter = printers.any((p) => p.name == savedReceipt) 
            ? savedReceipt 
            : (printers.isNotEmpty ? printers.first.name : null);
            
        _selectedStickerPrinter = printers.any((p) => p.name == savedSticker) 
            ? savedSticker 
            : (printers.isNotEmpty ? printers.first.name : null);
            
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    if (_selectedReceiptPrinter != null) {
      await PrinterPrefs.saveReceiptPrinter(_selectedReceiptPrinter!);
    }
    if (_selectedStickerPrinter != null) {
      await PrinterPrefs.saveStickerPrinter(_selectedStickerPrinter!);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ إعدادات الطابعات بنجاح', textDirection: TextDirection.rtl),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
       
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تخصيص طابعات الكاشير والباركود',
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'اختر الطابعة المناسبة لكل مهمة لكي يوجهها النظام تلقائياً عند الطباعة.',
                      style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 30.h),

                    // قائمة طابعة الفواتير
                    DropdownButtonFormField<String>(
                      value: _selectedReceiptPrinter,
                      decoration: const InputDecoration(
                        labelText: 'طابعة الفواتير (80mm - XP-80T)',
                        border: OutlineInputBorder(),
                      ),
                      items: _printers.map((printer) {
                        return DropdownMenuItem(
                          value: printer.name,
                          child: Text(printer.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedReceiptPrinter = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.h),

                    // قائمة طابعة الستيكرات
                    DropdownButtonFormField<String>(
                      value: _selectedStickerPrinter,
                      decoration: const InputDecoration(
                        labelText: 'طابعة الستيكرات والباركود (50x30 - XP-235B)',
                        border: OutlineInputBorder(),
                      ),
                      items: _printers.map((printer) {
                        return DropdownMenuItem(
                          value: printer.name,
                          child: Text(printer.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStickerPrinter = val;
                        });
                      },
                    ),
                    SizedBox(height: 40.h),
                    PrimaryButton(
                      onTap: _saveSettings,
                      buttonText: 'حفظ الإعدادات',
                    ),

                 
                  ],
                ),
              ),
      ),
    );
  }
}