import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/kpi/domain/entities/complaints_entity.dart';
import 'package:andersen/features/kpi/domain/repositories/complaints_repository.dart';
import 'package:dartz/dartz.dart';

class GetComplaintsUsecase {
  final ComplaintsRepository repository;

  GetComplaintsUsecase(this.repository);

  Future<Either<Failure, ComplaintsEntity>> call({required ComplaintsRequest request}) {
    return repository.getComplaints(request: request);
  }
}
