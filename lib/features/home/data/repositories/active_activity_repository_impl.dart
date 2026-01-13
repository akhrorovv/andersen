import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/data/sources/active_activity_remote_data_source.dart';
import 'package:andersen/features/home/domain/repositories/active_activity_repository.dart';
import 'package:dartz/dartz.dart';

class ActiveActivityRepositoryImpl implements ActiveActivityRepository {
  final ActiveActivityRemoteDataSource remoteDataSource;

  ActiveActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivityEntity?>> getActiveActivity() async {
    try {
      final result = await remoteDataSource.getActiveActivity();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
