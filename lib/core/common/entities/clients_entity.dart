import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:equatable/equatable.dart';

class ClientsEntity extends Equatable {
  final MetaEntity meta;
  final List<ClientEntity> clients;

  const ClientsEntity({required this.meta, required this.clients});

  @override
  List<Object?> get props => [meta, clients];
}
