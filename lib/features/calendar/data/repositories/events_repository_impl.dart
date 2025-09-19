import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/events_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  EventsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EventsEntity>> getEvents({
    required int limit,
    required int offset,
    required int attendeeId,
    required DateTime dateMin,
    required DateTime dateMax,
    String? search,
    String? target,
    int? matterId,
  }) async {
    try {
      final result = await remoteDataSource.getEvents(
        offset: offset,
        limit: limit,
        attendeeId: attendeeId,
        dateMin: dateMin,
        dateMax: dateMax,
        search: search,
        target: target,
        matterId: matterId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
