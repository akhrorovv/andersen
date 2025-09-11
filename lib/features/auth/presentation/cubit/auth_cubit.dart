import 'package:andersen/core/error/failure.dart';
import 'package:andersen/features/auth/domain/entities/login_response.dart';
import 'package:andersen/features/auth/domain/usecases/login_params.dart';
import 'package:andersen/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(AuthInitial());

  Future<void> login(LoginParams params) async {
    emit(AuthLoading());

    final result = await loginUseCase(params);

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (response) => emit(AuthSuccess(response)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
