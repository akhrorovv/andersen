import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class EventDetailRepository {
  Future<Either<Failure, EventEntity>> getEventDetail({required int eventId});
}
