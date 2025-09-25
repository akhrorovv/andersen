import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/start_activity_repository.dart';
import 'package:dartz/dartz.dart';

class StartActivityUsecase {
  final StartActivityRepository repository;

  StartActivityUsecase(this.repository);

  Future<Either<Failure, ActivityEntity>> call(Map<String, dynamic> body) async {
    return await repository.startActivity(body);
  }
}
