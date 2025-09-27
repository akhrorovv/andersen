import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class StopActivityRepository {
  Future<Either<Failure, ActivityEntity>> stopActivity(int activityId, Map<String, dynamic> body);
}
