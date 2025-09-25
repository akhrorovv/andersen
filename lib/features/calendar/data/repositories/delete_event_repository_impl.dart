import 'package:andersen/core/error/exceptions.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/calendar/data/sources/delete_event_remote_data_source.dart';
import 'package:andersen/features/calendar/domain/repositories/delete_event_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteEventRepositoryImpl implements DeleteEventRepository {
  final DeleteEventRemoteDataSource remoteDataSource;

  DeleteEventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> deleteEvent(int eventId) async {
    try {
      final result = await remoteDataSource.deleteEvent(eventId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
