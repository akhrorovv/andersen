import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_types_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class TaskTypesRepository {
  Future<Either<Failure, TaskTypesEntity>> getTypes({
    required int limit,
    required int offset,
    String? search,
  });
}
