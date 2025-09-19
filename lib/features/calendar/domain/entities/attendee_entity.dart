import 'package:equatable/equatable.dart';

class AttendeeEntity extends Equatable {
  final int id;
  final String? name;
  final String? phone;

  const AttendeeEntity({required this.id, this.name, this.phone});

  @override
  List<Object?> get props => [id, name, phone];
}
