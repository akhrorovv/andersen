import 'package:andersen/features/kpi/domain/entities/avg_entity.dart';
import 'package:andersen/features/kpi/domain/entities/count_entity.dart';
import 'package:andersen/features/kpi/domain/entities/sum_entity.dart';
import 'package:equatable/equatable.dart';

class KpiUserEntity extends Equatable {
  final AvgEntity? avg;
  final SumEntity? sum;
  final CountEntity? count;

  const KpiUserEntity({required this.avg, required this.sum, this.count});

  @override
  List<Object?> get props => [avg, sum, count];
}
