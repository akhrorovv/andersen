import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/data/sources/activities_remote_data_source.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';
import 'package:andersen/features/activities/domain/repositories/activity_repository.dart';
import 'package:dartz/dartz.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivitiesRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivitiesEntity>> getActivities({
    required int offset,
    required int limit,
    int? createdById,
  }) async {
    try {
      final result = await remoteDataSource.getActivities(
        offset: offset,
        limit: limit,
        createdById: createdById,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
