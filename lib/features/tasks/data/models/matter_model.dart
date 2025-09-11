import 'package:andersen/features/tasks/data/models/contract_model.dart';
import 'package:andersen/features/tasks/data/models/practice_area_model.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';

class MatterModel extends MatterEntity {
  const MatterModel({
    required super.id,
    required super.status,
    required super.name,
    super.contract,
    super.practiceArea,
  });

  factory MatterModel.fromJson(Map<String, dynamic> json) {
    return MatterModel(
      id: json['id'] as int,
      status: json['status'] ?? '',
      name: json['name'] ?? '',
      contract: json['contract'] != null
          ? ContractModel.fromJson(json['contract'] as Map<String, dynamic>)
          : null,
      practiceArea: json['practice_area'] != null
          ? PracticeAreaModel.fromJson(
              json['practice_area'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'contract': contract is ContractModel
          ? (contract as ContractModel).toJson()
          : null,
      'practice_area': practiceArea is PracticeAreaModel
          ? (practiceArea as PracticeAreaModel).toJson()
          : null,
    };
  }
}
