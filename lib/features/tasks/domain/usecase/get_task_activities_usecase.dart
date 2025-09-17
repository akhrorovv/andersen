import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetTaskActivitiesUsecase {
  final TaskDetailRepository repository;

  GetTaskActivitiesUsecase(this.repository);

  Future<Either<Failure, ActivitiesEntity>> call({
    required int limit,
    required int offset,
    int? createdById,
    required int taskId,
  }) async {
    return await repository.getTaskActivities(
      limit: limit,
      offset: offset,
      createdById: createdById,
      taskId: taskId,
    );
  }
}
