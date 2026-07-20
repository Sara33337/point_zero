import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// خطأ بيحصل في قاعدة البيانات المحلية (مثل: فشل إضافة منتج، داتابيز مقفولة)
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.message);
}

// خطأ بيحصل لما ندور على حاجة ومنلاقيهاش (مثل: كود منتج مش موجود في المخزن)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

// خطأ بيحصل في تسجيل الدخول (مثل: الباسورد غلط، أو اليوزر مش موجود)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// خطأ بيحصل لو بنعمل عملية حسابية غلط أو داتا ناقصة
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}