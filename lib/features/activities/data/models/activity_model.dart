import 'package:andersen/features/activities/data/models/activity_type_model.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:andersen/features/tasks/data/models/contract_model.dart';
import 'package:andersen/features/tasks/data/models/matter_model.dart';
import 'package:andersen/features/tasks/data/models/task_model.dart';

class ActivityModel extends ActivityEntity {
  const ActivityModel({
    required super.id,
    super.date,
    super.lastEndTime,
    super.lastStartTime,
    super.runTimeInSeconds,
    super.userEnteredTimeInSeconds,
    super.description,
    super.typeId,
    super.billingPeriodId,
    super.contractId,
    super.matterId,
    super.taskId,
    super.deviceId,
    super.kpiId,
    super.createdAt,
    super.endedAt,
    super.updatedAt,
    super.createdById,
    super.matter,
    super.contract,
    super.task,
    super.type,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      lastEndTime: json['lastEndTime'] != null
          ? DateTime.tryParse(json['lastEndTime'])
          : null,
      lastStartTime: json['lastStartTime'] != null
          ? DateTime.tryParse(json['lastStartTime'])
          : null,
      runTimeInSeconds: json['runTimeInSeconds'] as int,
      userEnteredTimeInSeconds: json['userEnteredTimeInSeconds'] as int,
      description: json['description'] as String?,
      typeId: json['typeId'] as int?,
      billingPeriodId: json['billingPeriodId'] as int?,
      contractId: json['contractId'] as int?,
      matterId: json['matterId'] as int?,
      taskId: json['taskId'] as int?,
      deviceId: json['deviceId'] as String?,
      kpiId: json['kpiId'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.tryParse(json['endedAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      createdById: json['createdById'] as int?,
      matter: json['matter'] != null
          ? MatterModel.fromJson(json['matter'])
          : null,
      contract: json['contract'] != null
          ? ContractModel.fromJson(json['contract'])
          : null,
      task: json['task'] != null ? TaskModel.fromJson(json['task']) : null,
      type: json['type'] != null
          ? ActivityTypeModel.fromJson(json['type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'lastEndTime': lastEndTime?.toIso8601String(),
      'lastStartTime': lastStartTime?.toIso8601String(),
      'runTimeInSeconds': runTimeInSeconds,
      'userEnteredTimeInSeconds': userEnteredTimeInSeconds,
      'description': description,
      'typeId': typeId,
      'billingPeriodId': billingPeriodId,
      'contractId': contractId,
      'matterId': matterId,
      'taskId': taskId,
      'deviceId': deviceId,
      'kpiId': kpiId,
      'createdAt': createdAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdById': createdById,
      'matter': (matter as MatterModel?)?.toJson(),
      'contract': (contract as ContractModel?)?.toJson(),
      'task': (task as TaskModel?)?.toJson(),
      'type': (type as ActivityTypeModel?)?.toJson(),
    };
  }
}
