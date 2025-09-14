import 'package:andersen/features/activities/domain/entities/activity_type_entity.dart';
import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/features/tasks/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int id;
  final DateTime? date;
  final DateTime? lastEndTime;
  final DateTime? lastStartTime;
  final int? runTimeInSeconds;
  final int? userEnteredTimeInSeconds;
  final String? description;
  final int? typeId;
  final dynamic billingPeriodId;
  final dynamic contractId;
  final dynamic matterId;
  final int? taskId;
  final String? deviceId;
  final dynamic kpiId;
  final DateTime? createdAt;
  final dynamic endedAt;
  final DateTime? updatedAt;
  final int? createdById;
  final MatterEntity? matter;
  final dynamic contract;
  final TaskEntity? task;
  final ActivityTypeEntity? type;

  const ActivityEntity({
    required this.id,
    this.date,
    this.lastEndTime,
    this.lastStartTime,
    this.runTimeInSeconds,
    this.userEnteredTimeInSeconds,
    this.description,
    this.typeId,
    this.billingPeriodId,
    this.contractId,
    this.matterId,
    this.taskId,
    this.deviceId,
    this.kpiId,
    this.createdAt,
    this.endedAt,
    this.updatedAt,
    this.createdById,
    this.matter,
    this.contract,
    this.task,
    this.type,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    lastEndTime,
    lastStartTime,
    runTimeInSeconds,
    userEnteredTimeInSeconds,
    description,
    typeId,
    billingPeriodId,
    contractId,
    matterId,
    taskId,
    deviceId,
    kpiId,
    createdAt,
    endedAt,
    updatedAt,
    createdById,
    matter,
    contract,
    task,
    type,
  ];
}
