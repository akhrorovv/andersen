import 'package:andersen/core/common/models/meta_model.dart';
import 'package:andersen/core/common/models/user_model.dart';
import 'package:andersen/features/home/domain/entities/users_entity.dart';

class UsersModel extends UsersEntity {
  const UsersModel({required super.meta, required super.users});

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      meta: MetaModel.fromJson(json['meta']),
      users: (json['results'] as List<dynamic>? ?? []).map((t) => UserModel.fromJson(t)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': (meta as MetaModel).toJson(),
      'results': users.map((t) => (t as UserModel).toJson()).toList(),
    };
  }
}
