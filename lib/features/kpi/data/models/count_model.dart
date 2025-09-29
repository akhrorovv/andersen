import 'package:andersen/features/kpi/domain/entities/count_entity.dart';

class CountModel extends CountEntity {
  const CountModel({super.id});

  factory CountModel.fromJson(Map<String, dynamic> json) {
    return CountModel(id: (json['id'] as num?)?.toInt());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id};
  }
}
