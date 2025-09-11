import 'package:andersen/features/tasks/domain/entities/contract_entity.dart';

class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    super.description,
    super.type,
    super.status,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id'] as int,
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'type': type,
      'status': status,
    };
  }
}
