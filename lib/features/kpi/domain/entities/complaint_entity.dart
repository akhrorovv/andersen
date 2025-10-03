import 'package:andersen/core/common/entities/client_entity.dart';
import 'package:equatable/equatable.dart';

class ComplaintEntity extends Equatable {
  final int id;
  final String? comment;
  final ClientEntity? client;

  const ComplaintEntity({required this.id, this.comment, this.client});

  @override
  List<Object?> get props => [id, comment, client];
}
