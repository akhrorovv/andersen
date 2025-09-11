import 'package:andersen/features/tasks/data/models/task_model.dart';
import 'package:andersen/features/tasks/domain/entities/tasks_entity.dart';

class TasksModel extends TasksEntity {
  const TasksModel({required super.meta, required super.results});

  factory TasksModel.fromJson(Map<String, dynamic> json) {
    return TasksModel(
      meta: MetaModel.fromJson(json['meta']),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((t) => TaskModel.fromJson(t))
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
