import 'package:andersen/features/home/domain/usecases/get_profile_usecase.dart';
import 'package:andersen/features/home/presentation/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProfileUseCase getUserProfile;

  HomeCubit(this.getUserProfile) : super(HomeInitial());

  Future<void> getProfile() async {
    emit(HomeLoading());

    final result = await getUserProfile.call();

    result.fold((failure) => emit(HomeError(failure.message)), (user) => emit(HomeLoaded(user)));
  }
}
