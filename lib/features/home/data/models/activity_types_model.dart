import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/activities/data/models/activity_type_model.dart';
import 'package:andersen/features/home/domain/entities/activity_types_entity.dart';

class ActivityTypesModel extends ActivityTypesEntity {
  const ActivityTypesModel({required super.meta, required super.types});

  factory ActivityTypesModel.fromJson(Map<String, dynamic> json) {
    return ActivityTypesModel(
      meta: MetaModel.fromJson(json['meta']),
      types: (json['results'] as List<dynamic>? ?? [])
          .map((t) => ActivityTypeModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': types.map((t) => (t as ActivityTypeModel).toJson()).toList(),
    };
  }
}
