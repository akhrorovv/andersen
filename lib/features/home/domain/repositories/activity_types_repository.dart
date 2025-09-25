import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/entities/activity_types_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ActivityTypesRepository {
  Future<Either<Failure, ActivityTypesEntity>> getTypes({
    required int limit,
    required int offset,
    String? search,
  });
}
