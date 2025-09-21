import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final int? clientId;
  final String? status;
  final String? name;

  const ContractEntity({required this.id, this.clientId, this.status, this.name});

  @override
  List<Object?> get props => [id, clientId, status, name];
}
