import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:point_zero/features/auth/domain/entities/user_entity.dart';
import 'package:point_zero/features/auth/domain/repo/auth_repo.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(String username, String password) async {
    try {
      final userModel = await localDataSource.login(username, password);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    // In a local SQLite app, logout just clears the state in the UI (Cubit),
    // but we return Right(unit) to satisfy the repository contract.
    return const Right(unit);
  }
}