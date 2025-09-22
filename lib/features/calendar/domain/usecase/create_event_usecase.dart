import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/create_event_repository.dart';
import 'package:dartz/dartz.dart';

class CreateEventUsecase {
  final CreateEventRepository repository;

  CreateEventUsecase(this.repository);

  Future<Either<Failure, EventEntity>> call(Map<String, dynamic> body) async {
    return await repository.createEvent(body);
  }
}
