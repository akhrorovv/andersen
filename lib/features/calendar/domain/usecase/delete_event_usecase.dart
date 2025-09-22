import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/domain/repositories/delete_event_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteEventUsecase {
  final DeleteEventRepository repository;

  DeleteEventUsecase(this.repository);

  Future<Either<Failure, bool>> call(int eventId) async {
    return await repository.deleteEvent(eventId);
  }
}
