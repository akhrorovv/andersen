import 'package:andersen/features/kpi/domain/entities/workload_entity.dart';

class WorkloadModel extends WorkloadEntity {
  const WorkloadModel({required super.id, required super.name, required super.count});

  factory WorkloadModel.fromJson(Map<String, dynamic> json) {
    return WorkloadModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      count: CountModel.fromJson(json['count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'count': (count as CountModel).toJson()};
  }
}

class CountModel extends CountEntity {
  const CountModel({required super.tasks});

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(tasks: json['tasks'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'tasks': tasks};
  }
}
