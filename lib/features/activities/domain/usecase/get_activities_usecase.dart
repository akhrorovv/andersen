import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/activities/domain/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class GetActivitiesUsecase {
  final ActivityRepository repository;

  GetActivitiesUsecase(this.repository);

  Future<Either<Failure, ActivitiesEntity>> call({
    required int limit,
    required int offset,
  }) async {
    return await repository.getActivities(limit: limit, offset: offset);
  }
}
