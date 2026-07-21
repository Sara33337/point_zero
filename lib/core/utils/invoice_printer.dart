import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

class InvoicePrinter {
  static Future<void> printReceipt(BillEntity bill) async {
    final pdf = pw.Document();

    final arabicFont = await PdfGoogleFonts.tajawalMedium();
    final arabicFontBold = await PdfGoogleFonts.tajawalBold();

    final format = PdfPageFormat.roll80;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFontBold,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
     
              pw.Text('Point Zero ', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('فاتورة مبيعات', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('التاريخ: ${bill.createdAt.toString().substring(0, 16)}', style: const pw.TextStyle(fontSize: 10)),
              // pw.Text('رقم الفاتورة: ${bill.id}', style: const pw.TextStyle(fontSize: 10)),

              pw.SizedBox(height: 10),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),

       
              pw.Row(
                children: [
                  pw.Expanded(flex: 3, child: pw.Text('المنتج', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Expanded(flex: 1, child: pw.Text('الكمية', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                  pw.Expanded(flex: 2, child: pw.Text('السعر', textAlign: pw.TextAlign.left, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
                ],
              ),
              pw.Divider(borderStyle: pw.BorderStyle.dashed),

        
              ...bill.items.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    children: [
                      pw.Expanded(flex: 3, child: pw.Text(item.product.name, style: const pw.TextStyle(fontSize: 10))),
                      pw.Expanded(flex: 1, child: pw.Text('${item.quantity}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10))),
                      pw.Expanded(flex: 2, child: pw.Text('${item.unitPrice}', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
                    ],
                  ),
                );
              }),

              pw.Divider(borderStyle: pw.BorderStyle.dashed),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('الإجمالي المستحق:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text('${bill.totalAmount} ج.م', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 15),

            
              pw.Text('شكراً لزيارتكم!', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Text('Powered by Point Zero', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              pw.Text('( دمياط القديمة - أمام مصنع الثلج )', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
              pw.Text('البضاعة المباعة لا ترد ولكن تستبدل خلال 10 أيام', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),


            ],
          );
        },
      ),
    );

    // 4. استدعاء أمر الطباعة المباشر
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Invoice_${bill.id}',
    );
  }
}