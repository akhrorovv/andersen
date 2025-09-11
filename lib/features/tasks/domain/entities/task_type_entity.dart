import 'package:equatable/equatable.dart';

class TaskTypeEntity extends Equatable {
  final int id;
  final String? name;

  const TaskTypeEntity({required this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
