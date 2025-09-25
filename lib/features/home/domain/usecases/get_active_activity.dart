import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/home/domain/repositories/active_activity_repository.dart';
import 'package:dartz/dartz.dart';

class GetActiveActivity {
  final ActiveActivityRepository repository;

  GetActiveActivity(this.repository);

  Future<Either<Failure, ActivityEntity?>> call() async {
    return await repository.getActiveActivity();
  }
}
