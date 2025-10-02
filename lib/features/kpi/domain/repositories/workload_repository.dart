import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class WorkloadRepository {
  Future<Either<Failure, List<WorkloadEntity>>> getWorkload(WorkloadRequest request);
}

class WorkloadRequest {
  final String startDate;
  final String endDate;

  WorkloadRequest({required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() => {"endedAt.min": startDate, "endedAt.max": endDate};
}
