import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/data/sources/activity_types_remote_data_source.dart';
import 'package:andersen/features/home/domain/entities/activity_types_entity.dart';
import 'package:andersen/features/home/domain/repositories/activity_types_repository.dart';
import 'package:dartz/dartz.dart';

class ActivityTypesRepositoryImpl implements ActivityTypesRepository {
  final ActivityTypesRemoteDataSource remoteDataSource;

  ActivityTypesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ActivityTypesEntity>> getTypes({
    required int limit,
    required int offset,
    String? search,
  }) async {
    try {
      final result = await remoteDataSource.getTypes(
        offset: offset,
        limit: limit,
        search: search,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
