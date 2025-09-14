import 'package:andersen/features/tasks/data/models/matter_model.dart';
import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';

class MattersModel extends MattersEntity {
  const MattersModel({required super.meta, required super.results});

  factory MattersModel.fromJson(Map<String, dynamic> json) {
    return MattersModel(
      meta: MetaModel.fromJson(json['meta']),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((t) => MatterModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': results.map((t) => (t as TaskModel).toJson()).toList(),
    };
  }
}
