import 'package:andersen/features/kpi/domain/entities/avg_entity.dart';

class AvgModel extends AvgEntity {
  const AvgModel({
    super.value,
    super.matterScore,
    super.loyaltyScore,
    super.complaintScore,
    super.reviewScore,
    super.revenueScore,
    super.activityHoursScore,
    super.tasksScore,
    super.rating,
  });

  factory AvgModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic val) => (val as num?)?.toDouble();

    return AvgModel(
      value: toDouble(json['value']),
      matterScore: toDouble(json['matterScore']),
      loyaltyScore: toDouble(json['loyaltyScore']),
      complaintScore: toDouble(json['complaintScore']),
      reviewScore: toDouble(json['reviewScore']),
      revenueScore: toDouble(json['revenueScore']),
      activityHoursScore: toDouble(json['activityHoursScore']),
      tasksScore: toDouble(json['tasksScore']),
      rating: toDouble(json['rating']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'value': value,
      'matterScore': matterScore,
      'loyaltyScore': loyaltyScore,
      'complaintScore': complaintScore,
      'reviewScore': reviewScore,
      'revenueScore': revenueScore,
      'activityHoursScore': activityHoursScore,
      'tasksScore': tasksScore,
      'rating': rating,
    };
  }
}
