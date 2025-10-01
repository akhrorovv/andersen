import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_results_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_repository.dart';
import 'package:dartz/dartz.dart';

class GetKpiUsecase {
  final KpiRepository repository;

  GetKpiUsecase(this.repository);

  Future<Either<Failure, KpiResultsEntity>> call(KpiRequest request) {
    return repository.getKpi(request);
  }
}
