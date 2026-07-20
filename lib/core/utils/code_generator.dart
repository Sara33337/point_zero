import 'dart:math';

class CodeGenerator {
  static String generateProductCode() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    
    // 1. توليد حرفين عشوائيين
    String char1 = letters[random.nextInt(letters.length)];
    String char2 = letters[random.nextInt(letters.length)];
    
    int number = random.nextInt(100); 
    String numString = number.toString().padLeft(4, '0'); // تضمن ظهور صفر على اليسار إذا كان الرقم أقل من 10
    
    return '$char1$char2$numString'; // النتيجة مثلاً: AB1234
  }
}