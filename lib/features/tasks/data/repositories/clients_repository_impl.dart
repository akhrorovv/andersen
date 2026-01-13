import 'package:andersen/core/common/entities/clients_entity.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/data/sources/clients_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:dartz/dartz.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  final ClientsRemoteDataSource remoteDataSource;

  ClientsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ClientsEntity>> getClients({
    required int limit,
    required int offset,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getClients(
        offset: offset,
        limit: limit,
        search: search,
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
