import 'package:andersen/features/home/domain/entities/active_status_entity.dart';

class ActiveStatusModel extends ActiveStatusEntity {
  const ActiveStatusModel({required super.isActive, super.arrivedAt});

  factory ActiveStatusModel.fromJson(Map<String, dynamic> json) {
    return ActiveStatusModel(
      isActive: true,
      arrivedAt: json['arrivedAt'] != null
          ? DateTime.parse(json['arrivedAt'])
          : null,
    );
  }
}
