import 'package:andersen/features/activities/presentation/cubit/activity_detail_cubit.dart';
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
import 'package:andersen/features/tasks/data/repositories/clients_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/task_detail_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:andersen/features/tasks/data/sources/task_detail_remote_data_source.dart';
import 'package:andersen/features/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:andersen/features/tasks/domain/usecase/get_task_activities_usecase.dart';
import 'package:get_it/get_it.dart';

import 'core/api/dio_client.dart';
import 'features/activities/data/repositories/activity_detail_repository_impl.dart';
import 'features/activities/data/repositories/activity_repository_impl.dart';
import 'features/activities/data/sources/activities_remote_data_source.dart';
import 'features/activities/data/sources/activity_detail_remote_data_source.dart';
import 'features/activities/domain/repositories/activity_detail_repository.dart';
import 'features/activities/domain/repositories/activity_repository.dart';
import 'features/activities/domain/usecase/get_activities_usecase.dart';
import 'features/activities/domain/usecase/get_activity_detail_usecase.dart';
import 'features/activities/presentation/cubit/activities_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/tasks/data/repositories/matters_repository_impl.dart';
import 'features/tasks/data/sources/clients_remote_data_source.dart';
import 'features/tasks/data/sources/matters_remote_data_source.dart';
import 'features/tasks/domain/repositories/matters_repository.dart';
import 'features/tasks/domain/repositories/task_detail_repository.dart';
import 'features/tasks/domain/usecase/get_matters_usecase.dart';
import 'features/tasks/domain/usecase/get_task_detail_usecase.dart';
import 'features/tasks/domain/usecase/get_tasks_usecase.dart';
import 'features/tasks/domain/usecase/update_task_usecase.dart';
import 'features/tasks/presentation/cubit/matter_cubit.dart';
import 'features/tasks/presentation/cubit/task_activities_cubit.dart';
import 'features/tasks/presentation/cubit/task_detail_cubit.dart';
import 'features/tasks/presentation/cubit/task_update_cubit.dart';
import 'features/tasks/presentation/cubit/tasks_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<DioClient>(DioClient());

  _initAuth();
}

Future<void> _initAuth() async {
  sl
    /// Home
    ..registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(sl<DioClient>()))
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl<HomeRemoteDataSource>()))
    ..registerLazySingleton(() => GetProfileUseCase(sl<HomeRepository>()))
    ..registerLazySingleton(() => GetActiveStatusUseCase(sl<HomeRepository>()))
    ..registerLazySingleton(() => HomeCubit(sl<GetProfileUseCase>(), sl<GetActiveStatusUseCase>()))
    /// Auth
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<DioClient>()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()))
    ..registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()))
    ..registerFactory(() => AuthCubit(sl<LoginUseCase>()))
    /// Matters & Clients
    ..registerLazySingleton<MattersRemoteDataSource>(
      () => MattersRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<ClientsRemoteDataSource>(
          () => ClientsRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<MattersRepository>(
      () => MattersRepositoryImpl(sl<MattersRemoteDataSource>()),
    )
    ..registerLazySingleton<ClientsRepository>(
      () => ClientsRepositoryImpl(sl<ClientsRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetMattersUsecase(sl<MattersRepository>()))
    ..registerLazySingleton(() => MatterCubit(sl<GetMattersUsecase>()))
    /// Tasks
    ..registerLazySingleton<TasksRemoteDataSource>(() => TasksRemoteDataSourceImpl(sl<DioClient>()))
    ..registerLazySingleton<TaskDetailRemoteDataSource>(
      () => TaskDetailRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(sl<TasksRemoteDataSource>()))
    ..registerLazySingleton<TaskDetailRepository>(
      () => TaskDetailRepositoryImpl(sl<TaskDetailRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetTasksUseCase(sl<TasksRepository>()))
    ..registerLazySingleton(() => GetTaskDetailUseCase(sl<TaskDetailRepository>()))
    ..registerLazySingleton(() => GetTaskActivitiesUsecase(sl<TaskDetailRepository>()))
    ..registerLazySingleton(() => UpdateTaskUsecase(sl<TaskDetailRepository>()))
    ..registerLazySingleton(() => TasksCubit(sl<GetTasksUseCase>()))
    ..registerLazySingleton(() => TaskDetailCubit(sl<GetTaskDetailUseCase>()))
    ..registerFactory(() => TaskActivitiesCubit(sl<GetTaskActivitiesUsecase>()))
    ..registerFactory(() => TaskUpdateCubit(sl<UpdateTaskUsecase>()))
    /// Activities
    ..registerLazySingleton<ActivitiesRemoteDataSource>(
      () => ActivitiesRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<ActivityDetailRemoteDataSource>(
      () => ActivityDetailRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<ActivityRepository>(
      () => ActivityRepositoryImpl(sl<ActivitiesRemoteDataSource>()),
    )
    ..registerLazySingleton<ActivityDetailRepository>(
      () => ActivityDetailRepositoryImpl(sl<ActivityDetailRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetActivitiesUsecase(sl<ActivityRepository>()))
    ..registerLazySingleton(() => GetActivityDetailUsecase(sl<ActivityDetailRepository>()))
    ..registerLazySingleton(() => ActivitiesCubit(sl<GetActivitiesUsecase>()))
    ..registerFactory(() => ActivityDetailCubit(sl<GetActivityDetailUsecase>()));
}
