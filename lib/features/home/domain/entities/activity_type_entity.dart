import 'package:equatable/equatable.dart';

class ActivityTypeEntity extends Equatable {
  final int id;
  final String? name;

  const ActivityTypeEntity({required this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
