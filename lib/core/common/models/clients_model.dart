import 'package:andersen/core/common/entities/clients_entity.dart';
import 'package:andersen/core/common/models/client_model.dart';
import 'package:andersen/core/common/models/meta_model.dart';

class ClientsModel extends ClientsEntity {
  const ClientsModel({required super.meta, required super.clients});

  factory ClientsModel.fromJson(Map<String, dynamic> json) {
    return ClientsModel(
      meta: MetaModel.fromJson(json['meta']),
      clients: (json['results'] as List<dynamic>? ?? [])
          .map((t) => ClientModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': clients.map((t) => (t as ClientModel).toJson()).toList(),
    };
  }
}
