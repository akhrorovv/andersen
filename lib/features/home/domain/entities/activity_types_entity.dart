import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/activities/domain/entities/activity_type_entity.dart';
import 'package:equatable/equatable.dart';

class ActivityTypesEntity extends Equatable {
  final MetaEntity meta;
  final List<ActivityTypeEntity> types;

  const ActivityTypesEntity({required this.meta, required this.types});

  @override
  List<Object?> get props => [meta, types];
}
