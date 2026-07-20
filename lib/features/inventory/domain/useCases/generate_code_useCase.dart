import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/core/utils/code_generator.dart';
import 'package:point_zero/features/inventory/domain/repo/inventory_repo.dart';

class GenerateUniqueCodeUseCase {
  final InventoryRepository repository;

  GenerateUniqueCodeUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await _getUniqueCode();
  }

  Future<Either<Failure, String>> _getUniqueCode() async {
    // 1. توليد كود عشوائي مبدئي
    final candidateCode = CodeGenerator.generateProductCode();

    // 2. التحقق من وجوده في الداتابيز
    final result = await repository.checkCodeExists(candidateCode);

    return await result.fold(
      (failure) => Left(failure),
      (exists) async {
        if (exists) {
          return await _getUniqueCode();
        } else {
          return Right(candidateCode);
        }
      },
    );
  }
}