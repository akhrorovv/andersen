import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/kpi/data/models/kpi_model.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_results_entity.dart';

class KpiResultsModel extends KpiResultsEntity {
  const KpiResultsModel({required super.meta, required super.results});

  factory KpiResultsModel.fromJson(Map<String, dynamic> json) {
    return KpiResultsModel(
      meta: MetaModel.fromJson(json['meta']),
      results: (json['results'] as List<dynamic>? ?? []).map((t) => KpiModel.fromJson(t)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': results.map((t) => (t as KpiModel).toJson()).toList(),
    };
  }
}
