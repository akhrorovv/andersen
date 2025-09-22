import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/event_detail_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/event_detail_repository.dart';
import 'package:dartz/dartz.dart';

class EventDetailRepositoryImpl implements EventDetailRepository {
  final EventDetailRemoteDataSource remoteDataSource;

  EventDetailRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, EventEntity>> getEventDetail({required int eventId}) async {
    try {
      final result = await remoteDataSource.getEventDetail(eventId: eventId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
