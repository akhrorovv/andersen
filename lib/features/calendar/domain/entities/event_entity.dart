import 'package:andersen/features/calendar/domain/entities/attendee_entity.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String? description;
  final String? target;
  final String? location;
  final DateTime? endsAt;
  final DateTime? startsAt;
  final MatterEntity? matter;
  // final int? matterId;
  // final DateTime? createdAt;
  // final DateTime? updatedAt;
  // final int? createdById;
  // final List<AttendeeEntity>? attendees;
  // final UserEntity? createdBy;

  const EventEntity({
    required this.id,
    this.location,
    this.description,
    this.endsAt,
    this.startsAt,
    this.target,
    this.matter,
    // this.matterId,
    // this.createdAt,
    // this.updatedAt,
    // this.createdById,
    // this.attendees,
    // this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    location,
    description,
    endsAt,
    startsAt,
    target,
    matter,
    // matterId,
    // createdAt,
    // updatedAt,
    // createdById,
    // attendees,
    // createdBy,
  ];
}
