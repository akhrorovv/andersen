import 'package:equatable/equatable.dart';

class ContractEntity extends Equatable {
  final int id;
  final int? clientId;
  final String? status;

  const ContractEntity({required this.id, this.clientId, this.status});

  @override
  List<Object?> get props => [id, clientId, status];
}
