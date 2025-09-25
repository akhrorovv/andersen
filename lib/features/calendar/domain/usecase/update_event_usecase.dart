import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/create_event_repository.dart';
import 'package:andersen/features/calendar/domain/repositories/update_event_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateEventUsecase {
  final UpdateEventRepository repository;

  UpdateEventUsecase(this.repository);

  Future<Either<Failure, EventEntity>> call(int eventId, Map<String, dynamic> body) async {
    return await repository.updateEvent(eventId, body);
  }
}
