import 'package:andersen/core/common/entities/attendee_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class AttendeeStatusRepository {
  Future<Either<Failure, AttendeeEntity>> checkAttendeeStatus();

  Future<Either<Failure, AttendeeEntity>> arrive({
    required double latitude,
    required double longitude,
    String? lateReason,
  });

  Future<Either<Failure, AttendeeEntity>> leave({String? earlyReason});
}
