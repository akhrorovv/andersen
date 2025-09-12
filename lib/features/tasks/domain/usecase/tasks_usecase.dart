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
    String? status,
    String? search,
  }) async {
    return await repository.getTasks(
      limit: limit,
      offset: offset,
      status: status,
      search: search,
    );
  }
}
