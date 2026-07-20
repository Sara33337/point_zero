

import 'package:dartz/dartz.dart';
import 'package:point_zero/core/errors/failures.dart';
import 'package:point_zero/features/pos/domain/entities/bill_entity.dart';

abstract class PosRepository{
  Future<Either<Failure,Unit>> checkout(BillEntity bill);
}