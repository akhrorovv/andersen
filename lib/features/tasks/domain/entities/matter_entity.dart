import 'package:andersen/features/tasks/domain/entities/contract_entity.dart';
import 'package:equatable/equatable.dart';

class MatterEntity extends Equatable {
  final int id;
  final String name;
  final String? status;
  final ContractEntity? contract;

  const MatterEntity({required this.id, required this.name,  this.status, this.contract});

  @override
  List<Object?> get props => [id, name, status, contract];
}
