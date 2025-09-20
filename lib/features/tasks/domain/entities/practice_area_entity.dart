import 'package:equatable/equatable.dart';

class PracticeAreaEntity extends Equatable {
  final int? id;
  final String? name;
  final String? prefix;

  const PracticeAreaEntity({this.id, this.prefix, this.name});

  @override
  List<Object?> get props => [id, prefix, name];
}
