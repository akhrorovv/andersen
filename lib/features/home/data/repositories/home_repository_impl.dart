import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/home/data/sources/home_remote_data_source.dart';
import 'package:andersen/features/home/domain/entities/active_status_entity.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:andersen/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();

      // save user
      await DBService.saveUser(result);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, ActiveStatusEntity>> getActiveStatus() async {
    try {
      final result = await remoteDataSource.getActiveStatus();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
