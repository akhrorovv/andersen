import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_activities_repository.dart';
import 'package:dartz/dartz.dart';

class GetKpiActivitiesUsecase {
  final KpiActivitiesRepository repository;

  GetKpiActivitiesUsecase(this.repository);

  Future<Either<Failure, ActivitiesEntity>> call({
    required int limit,
    required int offset,
    required int createdById,
    required String startDate,
    required String endDate,
  }) async {
    return await repository.getKpiActivities(
      limit: limit,
      offset: offset,
      createdById: createdById,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
