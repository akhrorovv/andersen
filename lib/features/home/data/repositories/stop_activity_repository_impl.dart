import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/data/sources/stop_activity_remote_data_source.dart';
import 'package:andersen/features/home/domain/repositories/stop_activity_repository.dart';
import 'package:dartz/dartz.dart';

class StopActivityRepositoryImpl implements StopActivityRepository {
  final StopActivityRemoteDataSource remoteDataSource;

  StopActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivityEntity>> stopActivity(
    int activityId,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await remoteDataSource.stopActivity(activityId, body);
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
