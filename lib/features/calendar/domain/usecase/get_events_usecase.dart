import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';
import 'package:andersen/features/calendar/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';

class GetEventsUsecase {
  final EventsRepository repository;

  GetEventsUsecase(this.repository);

  Future<Either<Failure, EventsEntity>> call({
    required int limit,
    required int offset,
    required int attendeeId,
    required DateTime dateMin,
    required DateTime dateMax,
    String? search,
    String? target,
    int? matterId,
  }) async {
    return await repository.getEvents(
      offset: offset,
      limit: limit,
      attendeeId: attendeeId,
      dateMin: dateMin,
      dateMax: dateMax,
      search: search,
      target: target,
      matterId: matterId,
    );
  }
}
