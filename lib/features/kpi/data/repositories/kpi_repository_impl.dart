import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/data/sources/kpi_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_results_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/kpi_repository.dart';
import 'package:dartz/dartz.dart';

class KpiRepositoryImpl implements KpiRepository {
  final KpiRemoteDataSource remoteDataSource;

  KpiRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, KpiResultsEntity>> getKpi(KpiRequest request) async {
    try {
      final result = await remoteDataSource.getKpi(request);

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
