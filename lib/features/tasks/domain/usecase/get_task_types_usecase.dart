// import 'package:andersen/core/error/failure.dart';
// import 'package:andersen/features/tasks/domain/entities/matters_entity.dart';
// import 'package:andersen/features/tasks/domain/entities/task_types_entity.dart';
// import 'package:andersen/features/tasks/domain/repositories/matters_repository.dart';
// import 'package:andersen/features/tasks/domain/repositories/task_types_repository.dart';
// import 'package:dartz/dartz.dart';
//
// class GetTaskTypesUsecase {
//   final TaskTypesRepository repository;
//
//   GetTaskTypesUsecase(this.repository);
//
//   Future<Either<Failure, TaskTypesEntity>> call({
//     required int limit,
//     required int offset,
//     String? search,
//   }) async {
//     return await repository.getTypes(
//       limit: limit,
//       offset: offset,
//       search: search,
//     );
//   }
// }
