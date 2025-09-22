import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/create_event_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/create_event_repository.dart';
import 'package:dartz/dartz.dart';

class CreateEventRepositoryImpl implements CreateEventRepository {
  final CreateEventRemoteDataSource remoteDataSource;

  CreateEventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EventEntity>> createEvent(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.createEvent(body);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
