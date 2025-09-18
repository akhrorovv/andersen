import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final int clientId;
  final String? description;
  final String? type;
  final String? status;

  const ContractEntity({
    required this.id,
    required this.clientId,
    this.description,
    this.type,
    this.status,
  });

  @override
  List<Object?> get props => [id, clientId, description, type, status];
}
