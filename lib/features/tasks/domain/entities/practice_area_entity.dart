import 'package:equatable/equatable.dart';

class PracticeAreaEntity extends Equatable {
  final String? prefix;
  final String? name;

  const PracticeAreaEntity({this.prefix, this.name});

  @override
  List<Object?> get props => [prefix, name];
}
