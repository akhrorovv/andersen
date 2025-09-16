import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/activities/domain/repositories/activity_detail_repository.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetActivityDetailUsecase {
  final ActivityDetailRepository repository;

  GetActivityDetailUsecase(this.repository);

  Future<Either<Failure, ActivityEntity>> call(int activityId) {
    return repository.getActivityDetail(activityId: activityId);
  }
}
