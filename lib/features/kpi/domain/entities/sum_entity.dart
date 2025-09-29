import 'package:equatable/equatable.dart';

class SumEntity extends Equatable {
  final double? revenue;
  final double? durationInSeconds;
  final double? complaintsCount;
  final double? nonbilledTasks;
  final double? tasksCount;

  const SumEntity({
    this.revenue,
    this.durationInSeconds,
    this.complaintsCount,
    this.nonbilledTasks,
    this.tasksCount,
  });

  @override
  List<Object?> get props => [
    revenue,
    durationInSeconds,
    complaintsCount,
    nonbilledTasks,
    tasksCount,
  ];
}
