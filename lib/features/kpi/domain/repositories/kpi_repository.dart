import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_results_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class KpiRepository {
  Future<Either<Failure, KpiResultsEntity>> getKpi(KpiRequest request);
}

class KpiRequest {
  final int limit;
  final int offset;
  final int userId;
  final String startDate;
  final String endDate;

  KpiRequest({
    required this.limit,
    required this.offset,
    required this.userId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "userId": userId,
    "weekStart.min": startDate,
    "weekStart.max": endDate,
  };
}
