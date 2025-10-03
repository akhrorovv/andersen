import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ComplaintsRepository {
  Future<Either<Failure, ComplaintsEntity>> getComplaints({required ComplaintsRequest request});
}

class ComplaintsRequest {
  final int limit;
  final int offset;
  final int userId;
  final String startDate;
  final String endDate;

  ComplaintsRequest({
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
    "kpi.weekStart.min": startDate,
    "kpi.weekStart.max": endDate,
  };
}
