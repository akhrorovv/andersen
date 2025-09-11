import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final String? description;
  final String? type;
  final String? status;

  const ContractEntity({
    required this.id,
    this.description,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [id, description, type, status];
}
