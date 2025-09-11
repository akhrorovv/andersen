import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/entities/active_status_entity.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, UserEntity>> getProfile();

  Future<Either<Failure, ActiveStatusEntity>> getActiveStatus();
}
