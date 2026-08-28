import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:point_zero/features/exchange/domain/entities/past_sale_item.dart';

import 'package:point_zero/features/pos/domain/entities/cart_item_entity.dart';

import 'package:printing/printing.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class InvoicePrinter {
  static const String _storeName = 'Point Zero';
  static const String _address = '( دمياط القديمة - أمام مصنع الثلج )';
  static const String _phone = '01020942647';
  static const String _policy = 'البضاعة المباعة لا ترد ولكن تستبدل خلال 10 أيام';
  static const String _poweredBy = 'Powered by Point Zero';

  static Future<void> printReceipt(BillEntity bill) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final formattedDate = _getCurrentDate();

    pdf.addPage(
      _createPage(
        fonts: fonts,
        buildContent: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            _buildHeader(title: 'فاتورة مبيعات', date: formattedDate, fonts: fonts),
            // 👈 التعديل هنا: بعتنا المنتجات مباشرة بدون تحويل
            _buildProductsTable(bill.items, fonts),
            _buildTotalsRow('الإجمالي المستحق:', '${bill.totalAmount} ج.م', fonts),
            _buildFooter(fonts),
          ],
        ),
      ),
    );

    await _printPdf(pdf, 'Invoice_${bill.id}');
  }

  static Future<void> printExchangeReceipt({
    required PastSaleItemEntity returnedItem,
    required int returnQuantity,
    required List<CartItemEntity> replacementItems, // 👈 التعديل هنا: Entity
    required double returnCredit,
    required double replacementTotal,
    required double differencePaid,
  }) async {
    final pdf = pw.Document();
    final fonts = await _loadFonts();
    final formattedDate = _getCurrentDate();

    pdf.addPage(
      _createPage(
        fonts: fonts,
        buildContent: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(child: _buildHeader(title: 'إيصال استبدال', date: formattedDate, fonts: fonts)),
            _buildSectionTitle('المنتجات المُسترجعة:', fonts),
            _buildItemRow('${returnedItem.productName} (x$returnQuantity)', '- $returnCredit', fonts),
            pw.Divider(borderStyle: pw.BorderStyle.dashed),
            _buildSectionTitle('المنتجات البديلة:', fonts),
            ...replacementItems.map((item) => _buildItemRow('${item.product.name} (x${item.quantity})', '${item.subtotal}', fonts)).toList(),
            pw.Divider(),
            _buildItemRow('إجمالي البدائل:', '$replacementTotal', fonts),
            _buildItemRow('يُخصم رصيد المرتجع:', '- $returnCredit', fonts),
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.all(4),
              decoration: const pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.all(pw.Radius.circular(4))),
              child: _buildTotalsRow('الفرق المطلوب دفعه:', '$differencePaid جنيه', fonts),
            ),
            pw.Divider(),
            _buildFooter(fonts),
          ],
        ),
      ),
    );

    await _printPdf(pdf, 'Exchange_Receipt_${DateTime.now().millisecondsSinceEpoch}');
  }
 
  
  static Future<void> printProductStickers({
    required String productName,
    required String productCode,
    required double sellingPrice,
    required int quantity,
  }) async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('assets/fonts/Tajawal-Regular.ttf');
    final arabicFont = pw.Font.ttf(fontData);

    final double stickerWidth = 50 * 2.83;
    final double stickerHeight = 30 * 2.83;
    final margin = 2 * 2.83;

    final stickerFormat = PdfPageFormat(
      stickerWidth, 
      stickerHeight, 
      marginAll: margin,
    );

   
    for (int i = 0; i < quantity; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: stickerFormat,
          textDirection: pw.TextDirection.rtl,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
             
                  pw.Text(
                    productName,
                    style: pw.TextStyle(
                      font: arabicFont, 
                      fontSize: 12, 
                      fontWeight: pw.FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: pw.TextOverflow.clip,
                  ),
                  pw.SizedBox(height: 2),

                  pw.Text(
                    'السعر: $sellingPrice ج.م',
                    style: pw.TextStyle(
                      font: arabicFont, 
                      fontSize: 12, 
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 2),

                   pw.SizedBox(
                    
                    height: 35, 
                    width: double.infinity, 
                    child: pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(), 
                      data: productCode,
                      drawText: true, 
                   
                      textStyle: pw.TextStyle(
                        
  
                        font: arabicFont,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    // أمر الطباعة المباشر
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Stickers_$productCode',
    );
  }

  static pw.Widget _buildHeader({required String title, required String date, required Map<String, pw.Font> fonts}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(_storeName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: fonts['bold'])),
        pw.SizedBox(height: 5),
        pw.Text(title, style: pw.TextStyle(fontSize: 10, font: fonts['regular'])),
        pw.Text('التاريخ: $date', style: pw.TextStyle(fontSize: 10, font: fonts['regular'])),
        pw.SizedBox(height: 10),
        pw.Divider(borderStyle: pw.BorderStyle.dashed),
      ],
    );
  }

  static pw.Widget _buildProductsTable(List<CartItemEntity> items, Map<String, pw.Font> fonts) { // 👈 التعديل هنا: Entity
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(flex: 3, child: pw.Text('المنتج', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Expanded(flex: 1, child: pw.Text('الكمية', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Expanded(flex: 2, child: pw.Text('السعر', textAlign: pw.TextAlign.left, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
          ],
        ),
        pw.Divider(borderStyle: pw.BorderStyle.dashed),
        ...items.map((item) {
          final isDiscounted = item.unitPrice < item.product.sellingPrice;
          return pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              children: [
                pw.Expanded(flex: 3, child: pw.Text(item.product.name, style: pw.TextStyle(fontSize: 10, font: fonts['regular']))),
                pw.Expanded(flex: 1, child: pw.Text('${item.quantity}', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, font: fonts['regular']))),
                pw.Expanded(
                  flex: 2, 
                  child: pw.Container(
                    alignment: pw.Alignment.centerLeft, // محاذاة لليسار زي باقي الفاتورة
                    child: isDiscounted 
                      ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisSize: pw.MainAxisSize.min,
                          children: [
                            // 1. السعر القديم (رمادي ومشطوب)
                            pw.Text(
                              '${item.product.sellingPrice}', 
                              style: pw.TextStyle(
                                fontSize: 8, 
                                color: PdfColors.grey700, 
                                decoration: pw.TextDecoration.lineThrough, // علامة الشطب
                                font: fonts['regular'],
                              ),
                            ),
                            // 2. سعر البيع الفعلي (Bold)
                            pw.Text(
                              '${item.unitPrice}', 
                              style: pw.TextStyle(
                                fontSize: 10, 
                                font: fonts['bold'],
                              ),
                            ),
                          ],
                        )
                      // لو مفيش خصم، يعرض السعر العادي
                      : pw.Text('${item.unitPrice}', style: pw.TextStyle(fontSize: 10, font: fonts['regular'])),
                  ),
                ),
         
              ],
            ),
          );
        }),
        pw.Divider(borderStyle: pw.BorderStyle.dashed),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String title, Map<String, pw.Font> fonts) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(title, style: pw.TextStyle(font: fonts['bold'], fontSize: 12, fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _buildItemRow(String title, String trailing, Map<String, pw.Font> fonts) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(child: pw.Text(title, style: pw.TextStyle(font: fonts['regular'], fontSize: 10))),
          pw.Text(trailing, style: pw.TextStyle(font: fonts['regular'], fontSize: 10)),
        ],
      ),
    );
  }

  static pw.Widget _buildTotalsRow(String title, String amount, Map<String, pw.Font> fonts) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: fonts['bold'])),
        pw.Text(amount, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: fonts['bold'])),
      ],
    );
  }

  static pw.Widget _buildFooter(Map<String, pw.Font> fonts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 15),
        pw.Text('شكراً لزيارتكم!', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, font: fonts['bold'])),
        pw.SizedBox(height: 4),
        pw.Text(_poweredBy, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey, font: fonts['regular'])),
        pw.Text(_address, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey, font: fonts['regular'])),
        pw.Text(_phone, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey, font: fonts['regular'])),
        pw.Text(_policy, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey, font: fonts['regular'])),
      ],
    );
  }

  static Future<Map<String, pw.Font>> _loadFonts() async {
    final regular = pw.Font.ttf(await rootBundle.load('assets/fonts/Tajawal-Regular.ttf'));
    final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Tajawal-Bold.ttf'));
    return {'regular': regular, 'bold': bold};
  }

  static String _getCurrentDate() {
    return DateFormat('yyyy-MM-dd  hh:mm a').format(DateTime.now());
  }

  static pw.Page _createPage({required Map<String, pw.Font> fonts, required pw.WidgetBuilder buildContent}) {
    return pw.Page(
      pageFormat: PdfPageFormat.roll80,
      margin: const pw.EdgeInsets.all(12),
      textDirection: pw.TextDirection.rtl,
      theme: pw.ThemeData.withFont(base: fonts['regular'], bold: fonts['bold']),
      build: buildContent,
    );
  }

  static Future<void> _printPdf(pw.Document pdf, String fileName) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: fileName,
    );
  }
}