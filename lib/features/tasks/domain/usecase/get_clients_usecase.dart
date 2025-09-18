import 'package:andersen/core/common/entities/clients_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:dartz/dartz.dart';

class GetClientsUsecase {
  final ClientsRepository repository;

  GetClientsUsecase(this.repository);

  Future<Either<Failure, ClientsEntity>> call({
    required int limit,
    required int offset,
    String? search,
  }) async {
    return await repository.getClients(limit: limit, offset: offset, search: search);
  }
}
