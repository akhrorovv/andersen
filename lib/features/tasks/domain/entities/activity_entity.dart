import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int id;
  final DateTime? lastStartTime;
  final DateTime? lastEndTime;
  final int runTimeInSeconds;
  final int userEnteredTimeInSeconds;
  final String? description;

  const ActivityEntity({
    required this.id,
    this.lastStartTime,
    this.lastEndTime,
    required this.runTimeInSeconds,
    required this.userEnteredTimeInSeconds,
    this.description,
  });

  @override
  List<Object?> get props => [id, lastStartTime, lastEndTime, runTimeInSeconds];
}
