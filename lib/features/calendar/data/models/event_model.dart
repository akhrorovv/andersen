import 'package:andersen/features/calendar/data/models/attendee_model.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:andersen/features/home/data/models/user_model.dart';
import 'package:andersen/features/tasks/data/models/matter_model.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    super.location,
    super.description,
    super.endsAt,
    super.startsAt,
    super.target,
    super.matterId,
    super.createdAt,
    super.updatedAt,
    super.createdById,
    super.attendees,
    super.matter,
    super.createdBy,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"] as int,
      location: json["location"] as String?,
      description: json["description"] as String?,
      endsAt: json['endsAt'] != null ? DateTime.tryParse(json['endsAt']) : null,
      startsAt: json['startsAt'] != null ? DateTime.tryParse(json['startsAt']) : null,
      target: json["target"] as String?,
      matterId: json["matterId"] as int?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      createdById: json["createdById"] as int?,
      attendees: (json['attendees'] as List<dynamic>? ?? [])
          .map((t) => AttendeeModel.fromJson(t))
          .toList(),
      matter: json['matter'] != null ? MatterModel.fromJson(json['matter']) : null,
      createdBy: json["createdBy"] != null ? UserModel.fromJson(json["createdBy"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "description": description,
    "endsAt": endsAt?.toIso8601String(),
    "startsAt": startsAt?.toIso8601String(),
    "target": target,
    "matterId": matterId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "createdById": createdById,
    "attendees": attendees?.map((x) => (x as AttendeeModel).toJson()).toList(),
    'matter': (matter as MatterModel?)?.toJson(),
    "createdBy": (createdBy as UserModel?)?.toJson(),
  };
}
