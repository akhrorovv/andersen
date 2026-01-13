import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/update_event_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/update_event_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateEventRepositoryImpl implements UpdateEventRepository {
  final UpdateEventRemoteDataSource remoteDataSource;

  UpdateEventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EventEntity>> updateEvent(int eventId, Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSource.updateEvent(eventId, body);
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
