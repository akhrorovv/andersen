import 'package:andersen/core/common/entities/clients_entity.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class ClientsRepository {
  Future<Either<Failure, ClientsEntity>> getClients({
    required int limit,
    required int offset,
    String? search,
  });
}
