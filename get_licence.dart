import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  // كود الجهاز الذي ظهر لك
  String deviceId = "{422AF93A-EF07-463C-801B-8220389D7B39}";
  
  // كلمة السر الثابتة لديك
  String secretSalt = "SARAH_POINT_ZERO_2026_SECURE";
  
  // عملية التشفير بـ SHA-256
  var bytes = utf8.encode(deviceId + secretSalt);
  var activationKey = sha256.convert(bytes).toString();
  
  print("========================================");
  print("مفتاح التفعيل لهذا الجهاز هو: ");
  print(activationKey);
  print("========================================");
}