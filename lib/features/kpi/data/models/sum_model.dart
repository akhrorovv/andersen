import 'package:andersen/features/kpi/domain/entities/sum_entity.dart';

class SumModel extends SumEntity {
  const SumModel({
    super.revenue,
    super.durationInSeconds,
    super.complaintsCount,
    super.nonbilledTasks,
    super.tasksCount,
  });

  factory SumModel.fromJson(Map<String, dynamic> json) {
    return SumModel(
      revenue: (json['revenue'] as num?)?.toDouble(),
      durationInSeconds: (json['durationInSeconds'] as num?)?.toDouble(),
      complaintsCount: (json['complaintsCount'] as num?)?.toDouble(),
      nonbilledTasks: (json['nonbilledTasks'] as num?)?.toDouble(),
      tasksCount: (json['tasksCount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'revenue': revenue,
      'durationInSeconds': durationInSeconds,
      'complaintsCount': complaintsCount,
      'nonbilledTasks': nonbilledTasks,
      'tasksCount': tasksCount,
    };
  }
}
