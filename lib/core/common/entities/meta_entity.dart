import 'package:equatable/equatable.dart';

class MetaEntity extends Equatable {
  final int offset;
  final int limit;
  final int total;

  const MetaEntity({
    required this.offset,
    required this.limit,
    required this.total,
  });

  @override
  List<Object?> get props => [offset, limit, total];
}
