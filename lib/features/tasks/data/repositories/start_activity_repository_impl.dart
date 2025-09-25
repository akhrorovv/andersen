import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/data/sources/start_activity_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/repositories/start_activity_repository.dart';
import 'package:dartz/dartz.dart';

class StartActivityRepositoryImpl implements StartActivityRepository {
  final StartActivityRemoteDataSource remoteDataSource;

  StartActivityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivityEntity>> startActivity(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.startActivity(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
