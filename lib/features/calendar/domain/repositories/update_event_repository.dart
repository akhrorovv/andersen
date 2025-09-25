import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class UpdateEventRepository {
  Future<Either<Failure, EventEntity>> updateEvent(int eventId, Map<String, dynamic> body);
}
