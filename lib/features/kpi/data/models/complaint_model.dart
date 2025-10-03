import 'package:andersen/core/common/models/client_model.dart';
import 'package:andersen/features/kpi/domain/entities/complaint_entity.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({required super.id, super.comment, super.client});

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as int,
      comment: json['comment'] as String?,
      client: json['client'] != null ? ClientModel.fromJson(json['client']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'comment': comment, 'client': (client as ClientModel?)?.toJson()};
  }
}
