import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
import 'package:dartz/dartz.dart';

class GetMattersUsecase {
  final MattersRepository repository;

  GetMattersUsecase(this.repository);

  Future<Either<Failure, MattersEntity>> call({
    required int limit,
    required int offset,
    String? search,
    bool? taskCreatable,
  }) async {
    return await repository.getMatters(
      limit: limit,
      offset: offset,
      search: search,
      taskCreatable: taskCreatable,
    );
  }
}
