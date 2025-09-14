import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/activities/data/models/activity_model.dart';
import 'package:andersen/features/activities/domain/entities/activities_entity.dart';

class ActivitiesModel extends ActivitiesEntity {
  const ActivitiesModel({required super.meta, required super.results});

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) {
    return ActivitiesModel(
      meta: MetaModel.fromJson(json['meta']),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((t) => ActivityModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': results.map((t) => (t as ActivityModel).toJson()).toList(),
    };
  }
}
