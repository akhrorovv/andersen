import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/activities/domain/entities/activity_entity.dart';
import 'package:equatable/equatable.dart';

class ActivitiesEntity extends Equatable {
  final MetaEntity meta;
  final List<ActivityEntity> results;

  const ActivitiesEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}

