import 'package:andersen/core/common/entities/meta_entity.dart';
import 'package:andersen/features/home/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class UsersEntity extends Equatable {
  final MetaEntity meta;
  final List<UserEntity> users;

  const UsersEntity({required this.meta, required this.users});

  @override
  List<Object?> get props => [meta, users];
}
