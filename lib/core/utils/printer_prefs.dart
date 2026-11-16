
import 'package:shared_preferences/shared_preferences.dart';

class PrinterPrefs {
  static const String _receiptPrinterKey = 'saved_receipt_printer';
  static const String _stickerPrinterKey = 'saved_sticker_printer';

  // حفظ طابعة الفواتير
  static Future<void> saveReceiptPrinter(String printerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_receiptPrinterKey, printerName);
  }

  // جلب طابعة الفواتير (افتراضي XP-80T)
  static Future<String> getReceiptPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_receiptPrinterKey) ?? 'XP-80T'; 
  }

  // حفظ طابعة الستيكرات
  static Future<void> saveStickerPrinter(String printerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stickerPrinterKey, printerName);
  }

  // جلب طابعة الستيكرات (افتراضي XP-235B)
  static Future<String> getStickerPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_stickerPrinterKey) ?? 'XP-235B';
  }
}