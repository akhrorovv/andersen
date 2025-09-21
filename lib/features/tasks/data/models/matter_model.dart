import 'package:andersen/features/tasks/data/models/contract_model.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';

class MatterModel extends MatterEntity {
  const MatterModel({
    required super.id,
    required super.name,
     super.status,
    super.contract,
  });

  factory MatterModel.fromJson(Map<String, dynamic> json) {
    return MatterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String?,
      contract: json['contract'] != null
          ? ContractModel.fromJson(json['contract'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'contract': contract is ContractModel ? (contract as ContractModel).toJson() : null,
    };
  }
}
