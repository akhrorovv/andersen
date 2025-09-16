import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/data/sources/activity_detail_remote_data_source.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/activities/domain/repositories/activity_detail_repository.dart';
import 'package:andersen/features/tasks/data/sources/task_detail_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/task_detail_repository.dart';
import 'package:dartz/dartz.dart';

class ActivityDetailRepositoryImpl implements ActivityDetailRepository {
  final ActivityDetailRemoteDataSource remoteDataSource;

  ActivityDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivityEntity>> getActivityDetail({
    required int activityId,
  }) async {
    try {
      final result = await remoteDataSource.getActivityDetail(
        activityId: activityId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
