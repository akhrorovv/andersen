import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/create_task_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/create_task_repository.dart';
import 'package:dartz/dartz.dart';

class CreateTaskRepositoryImpl implements CreateTaskRepository {
  final CreateTaskRemoteDataSource remoteDataSource;

  CreateTaskRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TaskEntity>> createTask(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.createTask(body);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure.fromException(e));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
