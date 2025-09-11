import 'package:andersen/features/home/domain/usecases/activity_usecase.dart';
import 'package:andersen/features/home/domain/usecases/profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetProfileUseCase getUserProfile;
  final GetActiveStatusUseCase getActiveStatus;

  HomeCubit(this.getUserProfile, this.getActiveStatus) : super(HomeInitial());

  Future<void> loadUserAndStatus() async {
    emit(HomeLoading());

    final userResult = await getUserProfile();
    final statusResult = await getActiveStatus();

    userResult.fold((failure) => emit(HomeError(failure.message)), (user) {
      statusResult.fold(
        (failure) => emit(HomeError(failure.message)),
        (isActive) => emit(HomeLoaded(user, isActive)),
      );
    });
  }
}
