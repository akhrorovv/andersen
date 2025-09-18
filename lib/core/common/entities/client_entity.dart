import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final int id;
  final String? name;
  final String? type;
  final String? email;
  final String? phone;
  final String? website;
  final dynamic role;
  final String? country;
  final String? region;
  final String? city;
  final String? street;
  final String? zip;
  final String? building;
  final String? lastname;
  final String? middlename;
  final String? inn;
  final String? oked;
  final String? bankName;
  final String? bankAccountNumber;
  final dynamic bankCode;
  final dynamic birthday;
  final dynamic companyId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final int? createdById;
  final dynamic deletedById;

  const ClientEntity({
    required this.id,
    this.name,
    this.type,
    this.email,
    this.phone,
    this.website,
    this.role,
    this.country,
    this.region,
    this.city,
    this.street,
    this.zip,
    this.building,
    this.lastname,
    this.middlename,
    this.inn,
    this.oked,
    this.bankName,
    this.bankAccountNumber,
    this.bankCode,
    this.birthday,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdById,
    this.deletedById,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    email,
    phone,
    website,
    role,
    country,
    region,
    city,
    street,
    zip,
    building,
    lastname,
    middlename,
    inn,
    oked,
    bankName,
    bankAccountNumber,
    bankCode,
    birthday,
    companyId,
    createdAt,
    updatedAt,
    deletedAt,
    createdById,
    deletedById,
  ];
}
