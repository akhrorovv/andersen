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

  // Future<void> arrive(BuildContext context) async {
  //   try {
  //     emit(HomeLoading());
  //
  //     // Lokatsiya permission
  //     final permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       final req = await Geolocator.requestPermission();
  //       if (req == LocationPermission.denied ||
  //           req == LocationPermission.deniedForever) {
  //         await Geolocator.openAppSettings();
  //         emit(HomeError("Location is required!"));
  //         return;
  //       }
  //     }
  //
  //     // Lokatsiyani olish
  //     final position = await Geolocator.getCurrentPosition();
  //
  //     final now = DateTime.now();
  //     final startWork = DateTime(now.year, now.month, now.day, 9, 0);
  //
  //     String? lateReason;
  //     if (now.isAfter(startWork)) {
  //       // late_reason page ochiladi
  //       lateReason = await Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => ReasonPage()),
  //       );
  //
  //       if (lateReason == null) {
  //         emit(HomeError("Late reason is required"));
  //         return;
  //       }
  //     }
  //
  //     final body = {
  //       "latitude": position.latitude,
  //       "longitude": position.longitude,
  //       if (lateReason != null) "late_reason": lateReason,
  //     };
  //
  //     await repository.arrive(body);
  //
  //     emit(HomeLoaded(
  //       status: AttendanceStatus(isActive: true, arrivedAt: DateTime.now()),
  //     ));
  //   } catch (e) {
  //     emit(HomeError(e.toString()));
  //   }
  // }
}
