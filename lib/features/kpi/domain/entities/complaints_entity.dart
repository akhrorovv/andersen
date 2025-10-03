import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/kpi/domain/entities/complaint_entity.dart';
import 'package:equatable/equatable.dart';

class ComplaintsEntity extends Equatable {
  final MetaEntity meta;
  final List<ComplaintEntity> results;

  const ComplaintsEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}

