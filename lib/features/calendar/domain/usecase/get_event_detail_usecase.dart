import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/event_detail_repository.dart';
import 'package:dartz/dartz.dart';

class GetEventDetailUsecase {
  final EventDetailRepository repository;

  GetEventDetailUsecase(this.repository);

  Future<Either<Failure, EventEntity>> call(int eventId) {
    return repository.getEventDetail(eventId: eventId);
  }
}
