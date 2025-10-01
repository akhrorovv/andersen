import 'package:equatable/equatable.dart';

class KpiEntity extends Equatable {
  final int id;
  final int? value;

  const KpiEntity({required this.id, this.value});

  @override
  List<Object?> get props => [id, value];
}
