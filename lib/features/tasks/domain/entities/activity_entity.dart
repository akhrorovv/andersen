import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final int id;
  final DateTime? lastStartTime;
  final DateTime? lastEndTime;
  final int runTimeInSeconds;
  final int userEnteredTimeInSeconds;

  const ActivityEntity({
    required this.id,
    this.lastStartTime,
    this.lastEndTime,
    required this.runTimeInSeconds,
    required this.userEnteredTimeInSeconds,
  });

  @override
  List<Object?> get props => [id, lastStartTime, lastEndTime, runTimeInSeconds];
}
