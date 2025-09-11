import 'package:andersen/core/error/failure.dart';
import 'package:andersen/core/utils/db_service.dart';
import 'package:andersen/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:andersen/features/auth/domain/entities/login_response.dart';
import 'package:andersen/features/auth/domain/repositories/auth_repository.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginParams params) async {
    try {
      // deviceId ni localdan olish (DBService orqali)
      final deviceId = DBService.deviceId;
      final result = await remoteDataSource.login(params, deviceId: deviceId);

      // tokenlarni va deviceId ni saqlab qo'yish
      await DBService.saveDeviceId(result.deviceId);
      await DBService.saveTokens(result.tokens.access, result.tokens.refresh);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
