import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/features/calendar/data/models/event_model.dart';
import 'package:andersen/features/calendar/domain/entities/events_entity.dart';

class EventsModel extends EventsEntity {
  const EventsModel({required super.meta, required super.events});

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      meta: MetaModel.fromJson(json['meta']),
      events: (json['results'] as List<dynamic>? ?? []).map((t) => EventModel.fromJson(t)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': events.map((t) => (t as EventModel).toJson()).toList(),
    };
  }
}
