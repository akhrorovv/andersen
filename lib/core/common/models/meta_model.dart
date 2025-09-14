import 'package:andersen/core/common/entities/meta_entity.dart';

class MetaModel extends MetaEntity {
  const MetaModel({
    required super.offset,
    required super.limit,
    required super.total,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'offset': offset, 'limit': limit, 'total': total};
  }
}
