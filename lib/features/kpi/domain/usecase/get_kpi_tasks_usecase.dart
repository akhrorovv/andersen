import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_tasks_repository.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:dartz/dartz.dart';

class GetKpiTasksUsecase {
  final KpiTasksRepository repository;

  GetKpiTasksUsecase(this.repository);

  Future<Either<Failure, TasksEntity>> call({
    required int limit,
    required int offset,
    required int assignedStaffId,
    required String startDate,
    required String endDate,
  }) async {
    return await repository.getKpiTasks(
      limit: limit,
      offset: offset,
      assignedStaffId: assignedStaffId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
