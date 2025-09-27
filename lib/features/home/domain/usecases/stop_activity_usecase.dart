import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/domain/repositories/stop_activity_repository.dart';
import 'package:dartz/dartz.dart';

class StopActivityUsecase {
  final StopActivityRepository repository;

  StopActivityUsecase(this.repository);

  Future<Either<Failure, ActivityEntity>> call(int activityId, Map<String, dynamic> body) async {
    return await repository.stopActivity(activityId, body);
  }
}
