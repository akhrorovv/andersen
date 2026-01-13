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
      // id: int yoki string kelsa ham xavfsiz o'girish
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      // name: null kelsa bo'sh string berish (crash bo'lmasligi uchun)
      name: json['name']?.toString() ?? '',

      status: json['status']?.toString(),

      // contract: ichma-ich obyektlarni xavfsiz parse qilish
      contract: (json['contract'] != null && json['contract'] is Map<String, dynamic>)
          ? ContractModel.fromJson(json['contract'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      // contractni casting bilan toJson qilish
      'contract': contract is ContractModel
          ? (contract as ContractModel).toJson()
          : null,
    };
  }
}
