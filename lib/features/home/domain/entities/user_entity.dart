import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String status;

  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, phone, status];
}
