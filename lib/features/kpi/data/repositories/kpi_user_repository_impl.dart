import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/data/sources/kpi_user_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_user_repository.dart';
import 'package:dartz/dartz.dart';

class KpiUserRepositoryImpl implements KpiUserRepository {
  final KpiUserRemoteDataSource remoteDataSource;

  KpiUserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, KpiUserEntity>> getUserKpi({
    required int userId,
    required KpiUserRequest request,
  }) async {
    try {
      final result = await remoteDataSource.getUserKpi(userId: userId, request: request);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
