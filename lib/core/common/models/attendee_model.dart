import 'package:andersen/core/common/entities/attendee_entity.dart';

class AttendeeModel extends AttendeeEntity {
  const AttendeeModel({
    required super.id,
    super.name,
    super.phone,
    super.arrivedAt,
    super.leavedAt,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      arrivedAt: json['arrivedAt'] != null ? DateTime.parse(json['arrivedAt']) : null,
      leavedAt: json['leavedAt'] != null ? DateTime.parse(json['leavedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'arrivedAt': arrivedAt, 'leavedAt': leavedAt};
  }
}
