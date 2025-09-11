import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/entities/active_status_entity.dart';
import 'package:andersen/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetActiveStatusUseCase {
  final HomeRepository repository;

  GetActiveStatusUseCase(this.repository);

  Future<Either<Failure, ActiveStatusEntity>> call() {
    return repository.getActiveStatus();
  }
}
