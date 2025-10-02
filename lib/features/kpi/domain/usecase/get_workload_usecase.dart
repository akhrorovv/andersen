import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/workload_repository.dart';
import 'package:dartz/dartz.dart';

class GetWorkloadUsecase {
  final WorkloadRepository repository;

  GetWorkloadUsecase(this.repository);

  Future<Either<Failure, List<WorkloadEntity>>> call(WorkloadRequest request) {
    return repository.getWorkload(request);
  }
}
