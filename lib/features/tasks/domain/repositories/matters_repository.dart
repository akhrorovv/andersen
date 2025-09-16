import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class MattersRepository {
  Future<Either<Failure, MattersEntity>> getMatters({
    required int limit,
    required int offset,
    bool? taskCreatable,
    String? search,
  });
}
