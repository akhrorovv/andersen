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
  final int? createdById;

  const EventEntity({
    required this.id,
    this.location,
    this.description,
    this.endsAt,
    this.startsAt,
    this.target,
    this.matter,
    this.createdById,
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
    createdById,
  ];
}
