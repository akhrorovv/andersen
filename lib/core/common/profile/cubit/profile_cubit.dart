import 'package:andersen/core/common/profile/cubit/profile_state.dart';
import 'package:andersen/core/common/profile/usecase/get_profile_usecase.dart';
import 'package:andersen/core/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getUserProfile;

  ProfileCubit(this.getUserProfile) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final result = await getUserProfile.call();

    result.fold(
      (failure) => emit(ProfileLoadedError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (user) => emit(ProfileLoadedSuccess(user)),
    );
  }
}
