import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/kpi/data/sources/kpi_activities_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_activities_repository.dart';
import 'package:dartz/dartz.dart';

class KpiActivitiesRepositoryImpl implements KpiActivitiesRepository {
  final KpiActivitiesRemoteDataSource remoteDataSource;

  KpiActivitiesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivitiesEntity>> getKpiActivities({
    required int offset,
    required int limit,
    required int createdById,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final result = await remoteDataSource.getKpiActivities(
        offset: offset,
        limit: limit,
        createdById: createdById,
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
