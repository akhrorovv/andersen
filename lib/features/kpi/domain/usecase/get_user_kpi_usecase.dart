import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_user_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserKpiUsecase {
  final KpiUserRepository repository;

  GetUserKpiUsecase(this.repository);

  Future<Either<Failure, KpiUserEntity>> call(int userId, KpiUserRequest request) {
    return repository.getUserKpi(userId: userId, request: request);
  }
}
