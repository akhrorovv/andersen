import 'package:andersen/features/auth/data/repositories/auth_repository.dart';
import 'package:andersen/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:andersen/features/auth/domain/repositories/auth_repository.dart';
import 'package:andersen/features/auth/domain/usecases/login_usecase.dart';
import 'package:andersen/features/home/data/repositories/home_repository_impl.dart';
import 'package:andersen/features/home/data/sources/home_remote_data_source.dart';
import 'package:andersen/features/home/domain/repositories/home_repository.dart';
import 'package:andersen/features/home/domain/usecases/activity_usecase.dart';
import 'package:andersen/features/home/domain/usecases/profile_usecase.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:andersen/features/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:get_it/get_it.dart';

import 'core/api/dio_client.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tasks/domain/usecase/tasks_usecase.dart';
import 'features/tasks/presentation/cubit/tasks_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());

  _initAuth();
}

Future<void> _initAuth() async {
  sl
    /// Tasks
    ..registerLazySingleton<TasksRemoteDataSource>(
      () => TasksRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<TasksRepository>(
      () => TasksRepositoryImpl(sl<TasksRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetTasksUseCase(sl<TasksRepository>()))
    ..registerLazySingleton(() => TasksCubit(sl<GetTasksUseCase>()))
    /// Home
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(sl<HomeRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetProfileUseCase(sl<HomeRepository>()))
    ..registerLazySingleton(() => GetActiveStatusUseCase(sl<HomeRepository>()))
    ..registerLazySingleton(
      () => HomeCubit(sl<GetProfileUseCase>(), sl<GetActiveStatusUseCase>()),
    )
    /// Auth
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
    )
    ..registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()))
    ..registerLazySingleton(() => AuthCubit(sl<LoginUseCase>()));
}
