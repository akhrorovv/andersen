import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
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
  });

  // factory EventModel.fromJson(Map<String, dynamic> json) {
  //   return EventModel(
  //     id: json["id"] as int? ?? 0,
  //     location: json["location"] as String? ?? '',
  //     description: json["description"] as String? ?? '',
  //     endsAt: json['endsAt'] != null ? DateTime.tryParse(json['endsAt']) : null,
  //     startsAt: json['startsAt'] != null
  //         ? DateTime.tryParse(json['startsAt'])
  //         : null,
  //     target: json["target"] as String? ?? '',
  //     matter: json['matter'] != null
  //         ? MatterModel.fromJson(json['matter'] as Map<String, dynamic>)
  //         : null,
  //     createdById: json["createdById"] as int? ?? 0,
  //   );
  // }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    try {
      return EventModel(
        // id ni har doim int ga o'girish (String kelsa ham)
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? '0') ?? 0,

        location: json["location"]?.toString() ?? '',
        description: json["description"]?.toString() ?? '',

        // DateTime parsingni xavfsiz qilish
        endsAt: _parseDate(json['ends_at'] ?? json['endsAt']),
        startsAt: _parseDate(json['starts_at'] ?? json['startsAt']),

        target: json["target"]?.toString() ?? '',

        matter: json['matter'] != null
            ? MatterModel.fromJson(json['matter'] as Map<String, dynamic>)
            : null,

        createdById: json["createdById"] is int
            ? json["createdById"]
            : int.tryParse(json["createdById"]?.toString() ?? '0') ?? 0,
      );
    } catch (e, stack) {
      // Qayerda xato bo'lganini aniq ko'rish uchun
      print("Parsing error in EventModel: $e");
      print("Stacktrace: $stack");
      rethrow;
    }
  }

  // Yordamchi funksiya
  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is String) return DateTime.tryParse(date);
    if (date is int) return DateTime.fromMillisecondsSinceEpoch(date);
    return null;
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
  };
}
