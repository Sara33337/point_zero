import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/auth/domain/entities/user_entity.dart';
import 'package:point_zero/features/auth/domain/repo/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(String username, String password) async {
    return await repository.login(username, password);
  }
}