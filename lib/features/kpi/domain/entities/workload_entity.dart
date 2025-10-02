import 'package:equatable/equatable.dart';

class WorkloadEntity extends Equatable {
  final int id;
  final String name;
  final CountEntity count;

  const WorkloadEntity({required this.id, required this.name, required this.count});

  @override
  List<Object?> get props => [id, name, count];
}

class CountEntity extends Equatable {
  final int tasks;

  const CountEntity({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}
