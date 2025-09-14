import 'package:andersen/features/tasks/domain/entities/matter_entity.dart';
import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:equatable/equatable.dart';

class MattersEntity extends Equatable {
  final MetaEntity meta;
  final List<MatterEntity> results;

  const MattersEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}


