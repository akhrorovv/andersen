import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class KpiUserRepository {
  Future<Either<Failure, KpiUserEntity>> getUserKpi({
    required int userId,
    required KpiUserRequest request,
  });
}

class KpiUserRequest {
  final int limit;
  final int offset;
  final String startDate;
  final String endDate;

  KpiUserRequest({
    required this.limit,
    required this.offset,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "offset": offset,
    "weekStart.min": startDate,
    "weekStart.max": endDate,
  };
}
