import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetTaskDetailUseCase {
  final TaskDetailRepository repository;

  GetTaskDetailUseCase(this.repository);

  Future<Either<Failure, TaskEntity>> call(int taskId) {
    return repository.getTaskDetail(taskId: taskId);
  }
}
