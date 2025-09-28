import 'package:andersen/core/common/entities/attendee_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/domain/repositories/attendee_repository.dart';
import 'package:dartz/dartz.dart';

class ArriveAttendeeUsecase {
  final AttendeeStatusRepository repository;

  ArriveAttendeeUsecase(this.repository);

  Future<Either<Failure, AttendeeEntity>> call({
    required double latitude,
    required double longitude,
    String? lateReason,
  }) async {
    return await repository.arrive(
      latitude: latitude,
      longitude: longitude,
      lateReason: lateReason,
    );
  }
}
