import 'package:equatable/equatable.dart';

class AvgEntity extends Equatable {
  final double? value;
  final double? matterScore;
  final double? loyaltyScore;
  final double? complaintScore;
  final double? reviewScore;
  final double? revenueScore;
  final double? activityHoursScore;
  final double? tasksScore;
  final double? rating;

  const AvgEntity({
    this.value,
    this.matterScore,
    this.loyaltyScore,
    this.complaintScore,
    this.reviewScore,
    this.revenueScore,
    this.activityHoursScore,
    this.tasksScore,
    this.rating,
  });

  @override
  List<Object?> get props => [
    value,
    matterScore,
    loyaltyScore,
    complaintScore,
    reviewScore,
    revenueScore,
    activityHoursScore,
    tasksScore,
    rating,
  ];
}
