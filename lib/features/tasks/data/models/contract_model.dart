import 'package:andersen/features/tasks/domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  const ContractModel({required super.id, super.clientId, super.status, super.name});

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as int,
      clientId: json['clientId'] as int?,
      status: json['status'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'clientId': clientId, 'status': status, 'name': name};
  }
}
