import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/matters_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:dartz/dartz.dart';

class MattersRepositoryImpl implements MattersRepository {
  final MattersRemoteDataSource remoteDataSource;

  MattersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MattersEntity>> getMatters({
    required int limit,
    required int offset,
    required int clientId,
    String? search,
    bool? taskCreatable,
  }) async {
    try {
      final result = await remoteDataSource.getMatters(
        offset: offset,
        limit: limit,
        clientId: clientId,
        search: search,
        taskCreatable: taskCreatable,
      );
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
