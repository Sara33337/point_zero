// استثناء خاص بقاعدة البيانات
class LocalDatabaseException implements Exception {
  final String message;
  LocalDatabaseException({this.message = 'حدث خطأ في قاعدة البيانات المحلية'});
}

// استثناء خاص بعدم العثور على بيانات
class NotFoundException implements Exception {
  final String message;
  NotFoundException({this.message = 'لم يتم العثور على البيانات المطلوبة'});
}

// استثناء خاص بتسجيل الدخول والصلاحيات
class AuthException implements Exception {
  final String message;
  AuthException({this.message = 'بيانات الدخول غير صحيحة'});
}

// استثناء خاص بالبيانات غير الصالحة أو الناقصة
class ValidationException implements Exception {
  final String message;
  ValidationException({this.message = 'بيانات غير صالحة'});
}