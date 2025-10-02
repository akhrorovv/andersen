import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/data/sources/workload_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/workload_repository.dart';
import 'package:dartz/dartz.dart';

class WorkloadRepositoryImpl implements WorkloadRepository {
  final WorkloadRemoteDataSource remoteDataSource;

  WorkloadRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<WorkloadEntity>>> getWorkload(WorkloadRequest request) async {
    try {
      final result = await remoteDataSource.getWorkload(request);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
