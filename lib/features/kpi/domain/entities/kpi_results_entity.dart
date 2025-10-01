import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/kpi/domain/entities/kpi_entity.dart';
import 'package:equatable/equatable.dart';

class KpiResultsEntity extends Equatable {
  final MetaEntity meta;
  final List<KpiEntity> results;

  const KpiResultsEntity({required this.meta, required this.results});

  @override
  List<Object?> get props => [meta, results];
}

