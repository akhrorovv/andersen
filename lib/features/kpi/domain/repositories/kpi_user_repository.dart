import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class KpiUserRepository {
  Future<Either<Failure, KpiUserEntity>> getUserKpi({required int userId});
}
