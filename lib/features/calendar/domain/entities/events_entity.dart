import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/calendar/domain/entities/event_entity.dart';
import 'package:equatable/equatable.dart';

class EventsEntity extends Equatable {
  final MetaEntity meta;
  final List<EventEntity> events;

  const EventsEntity({required this.meta, required this.events});

  @override
  List<Object?> get props => [meta, events];
}
