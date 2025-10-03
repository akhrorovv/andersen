import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/data/sources/kpi_tasks_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_tasks_repository.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:dartz/dartz.dart';

class KpiTasksRepositoryImpl implements KpiTasksRepository {
  final KpiTasksRemoteDataSource remoteDataSource;

  KpiTasksRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TasksEntity>> getKpiTasks({
    required int limit,
    required int offset,
    required int assignedStaffId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final result = await remoteDataSource.getKpiTasks(
        offset: offset,
        limit: limit,
        assignedStaffId: assignedStaffId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
