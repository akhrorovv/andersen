import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class KpiTasksRepository {
  Future<Either<Failure, TasksEntity>> getKpiTasks({
    required int limit,
    required int offset,
    required int assignedStaffId,
    required String startDate,
    required String endDate,
  });
}
