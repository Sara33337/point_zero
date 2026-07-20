import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/exceptions.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/pos/data/data_sources/pos_local_dataSource.dart';
import 'package:point_zero/features/pos/data/models/bill_model.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';
import 'package:point_zero/features/pos/domain/repo/pos_repo.dart';

class PosRepositoryImpl implements PosRepository {
  final PosLocalDataSource localDataSource;

  PosRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> checkout(BillEntity bill) async {
    try {
      final result = BillModel.fromEntity(bill);

      await localDataSource.checkout(result);

      return const Right(unit);
    } on LocalDatabaseException catch (e) {
      return Left(LocalDatabaseFailure(e.message));
    } catch (e) {
      return Left(LocalDatabaseFailure('حدث خطأ غير متوقع: $e'));
    }
  }
}
