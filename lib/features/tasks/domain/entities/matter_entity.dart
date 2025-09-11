import 'package:andersen/features/tasks/domain/entities/contract_entity.dart';
import 'package:andersen/features/tasks/domain/entities/practice_area_entity.dart';
import 'package:equatable/equatable.dart';

class MatterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final ContractEntity? contract;
  final PracticeAreaEntity? practiceArea;

  const MatterEntity({
    required this.id,
    required this.name,
    required this.status,
    this.contract,
    this.practiceArea,
  });

  @override
  List<Object?> get props => [id, name, status, contract, practiceArea];
}
