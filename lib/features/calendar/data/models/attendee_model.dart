import 'package:andersen/features/calendar/domain/entities/attendee_entity.dart';

class AttendeeModel extends AttendeeEntity {
  const AttendeeModel({required super.id, super.name, super.phone});

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone};
  }
}
