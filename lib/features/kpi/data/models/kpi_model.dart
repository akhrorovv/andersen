import 'package:andersen/features/kpi/domain/entities/kpi_entity.dart';

class KpiModel extends KpiEntity {
  const KpiModel({required super.id, super.value});

  factory KpiModel.fromJson(Map<String, dynamic> json) {
    return KpiModel(id: json['id'] as int, value: json['value'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value};
  }
}
