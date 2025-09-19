import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class EventsRepository {
  Future<Either<Failure, EventsEntity>> getEvents({
    required int limit,
    required int offset,
    required int attendeeId,
    required DateTime dateMin,
    required DateTime dateMax,
    String? search,
    String? target,
    int? matterId,
  });
}
