import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/data/sources/complaints_remote_data_source.dart';
import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  final ComplaintsRemoteDataSource remoteDataSource;

  ComplaintsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ComplaintsEntity>> getComplaints({
    required ComplaintsRequest request,
  }) async {
    try {
      final result = await remoteDataSource.getComplaints(request);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
