import 'package:equatable/equatable.dart';

class AttendeeEntity extends Equatable {
  final int id;
  final String? name;
  final String? phone;
  final DateTime? arrivedAt;
  final DateTime? leavedAt;

  const AttendeeEntity({required this.id, this.name, this.phone, this.arrivedAt, this.leavedAt});

  @override
  List<Object?> get props => [id, name, phone, arrivedAt, leavedAt];
}
