import 'package:andersen/core/common/entities/attendee_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/repositories/attendee_repository.dart';
import 'package:dartz/dartz.dart';

class CheckAttendeeStatusUsecase {
  final AttendeeStatusRepository repository;

  CheckAttendeeStatusUsecase(this.repository);

  Future<Either<Failure, AttendeeEntity>> call() async {
    return await repository.checkAttendeeStatus();
  }
}
