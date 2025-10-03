import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/kpi/data/models/complaint_model.dart';
import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';

class ComplaintsModel extends ComplaintsEntity {
  const ComplaintsModel({required super.meta, required super.results});

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) {
    return ComplaintsModel(
      meta: MetaModel.fromJson(json['meta']),
      results: (json['results'] as List<dynamic>? ?? [])
          .map((t) => ComplaintModel.fromJson(t))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': results.map((t) => (t as ComplaintModel).toJson()).toList(),
    };
  }
}
