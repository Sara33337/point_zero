import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:point_zero/core/data/db_helper.dart';


class ActivationService {
  // هذه الكلمة السرية خاصة بكِ فقط (لا تعطيها لأحد وتكون ثابتة داخل الكود)
  static String get _secretSalt => dotenv.env['SECRET_SALT'] ?? '';

  // 1. جلب كود جهاز العميل
  static Future<String> getHardwareId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      // نأخذ الـ deviceId الخاص بالويندوز
      return windowsInfo.deviceId; 
    }
    return "UNKNOWN_DEVICE";
  }

  // 2. التحقق مما إذا كان التطبيق مفعل مسبقاً من الداتابيز
  static Future<bool> checkIsActivated() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('app_settings', limit: 1);
    if (result.isNotEmpty) {
      return result.first['is_activated'] == 1;
    }
    return false;
  }

  // 3. التحقق من السيريال الذي سيدخله العميل
  static Future<bool> activateApp(String enteredKey) async {
    String deviceId = await getHardwareId();
    
    // نقوم بدمج كود الجهاز مع الكلمة السرية وتشفيرهم
    var bytes = utf8.encode(deviceId + _secretSalt);
    var expectedKey = sha256.convert(bytes).toString();

    // إذا كان الكود الذي أدخله العميل يطابق الكود المشفر
    if (enteredKey == expectedKey) {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'app_settings',
        {'is_activated': 1, 'license_key': enteredKey},
        where: 'id = ?',
        whereArgs: [1],
      );
      return true;
    }
    return false;
  }
}