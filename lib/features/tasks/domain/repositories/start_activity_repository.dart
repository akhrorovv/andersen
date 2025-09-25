import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class StartActivityRepository {
  Future<Either<Failure, ActivityEntity>> startActivity(Map<String, dynamic> body);
}
