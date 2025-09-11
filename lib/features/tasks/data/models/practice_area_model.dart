import 'package:andersen/features/tasks/domain/entities/practice_area_entity.dart';

class PracticeAreaModel extends PracticeAreaEntity {
  const PracticeAreaModel({super.prefix, super.name});

  factory PracticeAreaModel.fromJson(Map<String, dynamic> json) {
    return PracticeAreaModel(
      prefix: json['prefix'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'prefix': prefix, 'name': name};
  }
}
