import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ActivityRepository {
  Future<Either<Failure, ActivitiesEntity>> getActivities({
    required int limit,
    required int offset,
  });
}
