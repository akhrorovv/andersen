import 'package:andersen/core/common/entities/attendee_entity.dart';
import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/home/data/sources/attendee_remote_data_source.dart';
import 'package:andersen/features/home/domain/repositories/attendee_repository.dart';
import 'package:dartz/dartz.dart';

class AttendeeStatusRepositoryImpl implements AttendeeStatusRepository {
  final AttendeeStatusRemoteDataSource remoteDataSource;

  AttendeeStatusRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AttendeeEntity>> checkAttendeeStatus() async {
    try {
      final result = await remoteDataSource.checkAttendeeStatus();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, AttendeeEntity>> arrive({
    required double latitude,
    required double longitude,
    String? lateReason,
  }) async {
    try {
      final result = await remoteDataSource.arrive(
        latitude: latitude,
        longitude: longitude,
        lateReason: lateReason,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, AttendeeEntity>> leave({String? earlyReason}) async {
    try {
      final result = await remoteDataSource.leave(earlyReason: earlyReason);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
