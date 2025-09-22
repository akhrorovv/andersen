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
    super.matter,
    super.createdById,
    // super.matterId,
    // super.createdAt,
    // super.updatedAt,
    // super.attendees,
    // super.createdBy,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"] as int,
      location: json["location"] as String?,
      description: json["description"] as String?,
      endsAt: json['endsAt'] != null ? DateTime.tryParse(json['endsAt']) : null,
      startsAt: json['startsAt'] != null ? DateTime.tryParse(json['startsAt']) : null,
      target: json["target"] as String?,
      matter: json['matter'] != null
          ? MatterModel.fromJson(json['matter'] as Map<String, dynamic>)
          : null,
      createdById: json["createdById"] as int?,
      // matterId: json["matterId"] as int?,
      // createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      // updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      // attendees: (json['attendees'] as List<dynamic>? ?? [])
      //     .map((t) => AttendeeModel.fromJson(t))
      //     .toList(),
      // createdBy: json["createdBy"] != null ? UserModel.fromJson(json["createdBy"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "location": location,
    "description": description,
    "endsAt": endsAt,
    "startsAt": startsAt,
    "target": target,
    'matter': matter is MatterModel ? (matter as MatterModel).toJson() : null,
    "createdById": createdById,
    // "matterId": matterId,
    // "createdAt": createdAt?.toIso8601String(),
    // "updatedAt": updatedAt?.toIso8601String(),
    // "attendees": attendees?.map((x) => (x as AttendeeModel).toJson()).toList(),
    // "createdBy": (createdBy as UserModel?)?.toJson(),
  };
}
