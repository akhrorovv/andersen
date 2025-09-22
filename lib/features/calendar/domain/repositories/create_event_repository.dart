import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class CreateEventRepository {
  Future<Either<Failure, EventEntity>> createEvent(Map<String, dynamic> body);
}
