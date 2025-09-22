import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:dartz/dartz.dart';

class GetTasksUseCase {
  final TasksRepository repository;

  GetTasksUseCase(this.repository);

  Future<Either<Failure, TasksEntity>> call({
    required int limit,
    required int offset,
    required int assignedStaffId,
    String? status,
    String? search,
    String? dueMin,
    String? dueMax,
  }) async {
    return await repository.getTasks(
      limit: limit,
      offset: offset,
      assignedStaffId: assignedStaffId,
      status: status,
      search: search,
      dueMin: dueMin,
      dueMax: dueMax,
    );
  }
}
