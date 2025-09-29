import 'package:andersen/features/kpi/data/models/avg_model.dart';
import 'package:andersen/features/kpi/data/models/count_model.dart';
import 'package:andersen/features/kpi/data/models/sum_model.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_user_entity.dart';

class KpiUserModel extends KpiUserEntity {
  const KpiUserModel({required super.avg, required super.sum, super.count});

  factory KpiUserModel.fromJson(Map<String, dynamic> json) {
    return KpiUserModel(
      avg: json['_avg'] != null ? AvgModel.fromJson(json['_avg']) : null,
      sum: json['_sum'] != null ? SumModel.fromJson(json['_sum']) : null,
      count: json['_count'] != null ? CountModel.fromJson(json['_count']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (avg != null) data['_avg'] = (avg as AvgModel).toJson();
    if (sum != null) data['_sum'] = (sum as SumModel).toJson();
    if (count != null) data['_count'] = (count as CountModel).toJson();
    return data;
  }
}
