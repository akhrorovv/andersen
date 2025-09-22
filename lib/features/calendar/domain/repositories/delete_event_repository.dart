import 'package:andersen/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class DeleteEventRepository {
  Future<Either<Failure, bool>> deleteEvent(int eventId);
}
