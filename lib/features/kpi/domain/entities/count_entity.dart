import 'package:equatable/equatable.dart';

class CountEntity extends Equatable {
  final int? id;

  const CountEntity({this.id});

  @override
  List<Object?> get props => [id];
}
