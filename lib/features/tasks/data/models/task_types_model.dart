import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:andersen/features/tasks/data/models/task_type_model.dart';
import 'package:andersen/features/tasks/domain/entities/task_types_entity.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';

class TaskTypesModel extends TaskTypesEntity {
  const TaskTypesModel({required super.meta, required super.types});

  factory TaskTypesModel.fromJson(Map<String, dynamic> json) {
    return TaskTypesModel(
      meta: MetaModel.fromJson(json['meta']),
      types: (json['results'] as List<dynamic>? ?? [])
          .map((t) => TaskTypeModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': types.map((t) => (t as TaskTypeModel).toJson()).toList(),
    };
  }
}
