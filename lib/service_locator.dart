import 'package:andersen/features/activities/presentation/cubit/activity_detail_cubit.dart';
import 'package:andersen/features/auth/data/repositories/auth_repository.dart';
import 'package:andersen/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:andersen/features/auth/domain/repositories/auth_repository.dart';
import 'package:andersen/features/auth/domain/usecases/login_usecase.dart';
import 'package:andersen/features/calendar/data/repositories/events_repository_impl.dart';
import 'package:andersen/features/home/data/repositories/attendee_repository_impl.dart';
import 'package:andersen/features/home/data/repositories/home_repository_impl.dart';
import 'package:andersen/features/home/data/sources/home_remote_data_source.dart';
import 'package:andersen/features/home/domain/repositories/home_repository.dart';
import 'package:andersen/features/home/domain/usecases/activity_usecase.dart';
import 'package:andersen/features/home/domain/usecases/get_profile_usecase.dart';
import 'package:andersen/features/home/presentation/cubit/home_cubit.dart';
import 'package:andersen/features/tasks/data/repositories/clients_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/create_task_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/task_detail_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/task_types_repository_impl.dart';
import 'package:andersen/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:andersen/features/tasks/data/sources/task_detail_remote_data_source.dart';
import 'package:andersen/features/tasks/data/sources/tasks_remote_data_source.dart';
import 'package:andersen/features/tasks/domain/repositories/clients_repository.dart';
import 'package:andersen/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:andersen/features/tasks/domain/usecase/create_task_usecase.dart';
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
import 'features/calendar/data/repositories/create_event_repository_impl.dart';
import 'features/calendar/data/repositories/delete_event_repository_impl.dart';
import 'features/calendar/data/repositories/event_detail_repository_impl.dart';
import 'features/calendar/data/repositories/update_event_repository_impl.dart';
import 'features/calendar/data/repositories/users_repository_impl.dart';
import 'features/calendar/data/sources/create_event_remote_data_source.dart';
import 'features/calendar/data/sources/delete_event_remote_data_source.dart';
import 'features/calendar/data/sources/event_detail_remote_data_source.dart';
import 'features/calendar/data/sources/events_remote_data_source.dart';
import 'features/calendar/data/sources/update_event_remote_data_source.dart';
import 'features/calendar/data/sources/users_remote_data_source.dart';
import 'features/calendar/domain/repositories/create_event_repository.dart';
import 'features/calendar/domain/repositories/delete_event_repository.dart';
import 'features/calendar/domain/repositories/event_detail_repository.dart';
import 'features/calendar/domain/repositories/events_repository.dart';
import 'features/calendar/domain/repositories/update_event_repository.dart';
import 'features/calendar/domain/repositories/users_repository.dart';
import 'features/calendar/domain/usecase/create_event_usecase.dart';
import 'features/calendar/domain/usecase/delete_event_usecase.dart';
import 'features/calendar/domain/usecase/get_event_detail_usecase.dart';
import 'features/calendar/domain/usecase/get_events_usecase.dart';
import 'features/calendar/domain/usecase/get_users_usecase.dart';
import 'features/calendar/domain/usecase/update_event_usecase.dart';
import 'features/calendar/presentation/cubit/create_event_cubit.dart';
import 'features/calendar/presentation/cubit/delete_event_cubit.dart';
import 'features/calendar/presentation/cubit/event_detail_cubit.dart';
import 'features/calendar/presentation/cubit/events_cubit.dart';
import 'features/calendar/presentation/cubit/update_event_cubit.dart';
import 'features/home/data/repositories/active_activity_repository_impl.dart';
import 'features/home/data/repositories/activity_types_repository_impl.dart';
import 'features/home/data/repositories/stop_activity_repository_impl.dart';
import 'features/home/data/sources/active_activity_remote_data_source.dart';
import 'features/home/data/sources/activity_types_remote_data_source.dart';
import 'features/home/data/sources/attendee_remote_data_source.dart';
import 'features/home/data/sources/stop_activity_remote_data_source.dart';
import 'features/home/domain/repositories/active_activity_repository.dart';
import 'features/home/domain/repositories/activity_types_repository.dart';
import 'features/home/domain/repositories/attendee_repository.dart';
import 'features/home/domain/repositories/stop_activity_repository.dart';
import 'features/home/domain/usecases/arrive_attendee_usecase.dart';
import 'features/home/domain/usecases/check_attendee_status_usecase.dart';
import 'features/home/domain/usecases/get_active_activity.dart';
import 'features/home/domain/usecases/leave_attendee_usecase.dart';
import 'features/home/domain/usecases/stop_activity_usecase.dart';
import 'features/home/presentation/cubit/activity_status_cubit.dart';
import 'features/home/presentation/cubit/attendee_cubit.dart';
import 'features/home/presentation/cubit/stop_activity_cubit.dart';
import 'features/tasks/data/repositories/matters_repository_impl.dart';
import 'features/tasks/data/repositories/start_activity_repository_impl.dart';
import 'features/tasks/data/sources/clients_remote_data_source.dart';
import 'features/tasks/data/sources/create_task_remote_data_source.dart';
import 'features/tasks/data/sources/matters_remote_data_source.dart';
import 'features/tasks/data/sources/start_activity_remote_data_source.dart';
import 'features/tasks/data/sources/task_types_remote_data_source.dart';
import 'features/tasks/domain/repositories/create_task_repository.dart';
import 'features/tasks/domain/repositories/matters_repository.dart';
import 'features/tasks/domain/repositories/start_activity_repository.dart';
import 'features/tasks/domain/repositories/task_detail_repository.dart';
import 'features/tasks/domain/repositories/task_types_repository.dart';
import 'features/tasks/domain/usecase/get_matters_usecase.dart';
import 'features/tasks/domain/usecase/get_task_detail_usecase.dart';
import 'features/tasks/domain/usecase/get_tasks_usecase.dart';
import 'features/tasks/domain/usecase/start_activity_usecase.dart';
import 'features/tasks/domain/usecase/update_task_usecase.dart';
import 'features/tasks/presentation/cubit/create_task_cubit.dart';
import 'features/tasks/presentation/cubit/matter_cubit.dart';
import 'features/tasks/presentation/cubit/start_activity_cubit.dart';
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
    ..registerLazySingleton(() => HomeCubit(sl<GetProfileUseCase>()))
    /// Auth
    ..registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<DioClient>()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()))
    ..registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()))
    ..registerFactory(() => AuthCubit(sl<LoginUseCase>()))
    /// Matters & Clients & types
    // matter
    ..registerLazySingleton<MattersRemoteDataSource>(
      () => MattersRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<MattersRepository>(
      () => MattersRepositoryImpl(sl<MattersRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetMattersUsecase(sl<MattersRepository>()))
    // task
    ..registerLazySingleton<TaskTypesRemoteDataSource>(
      () => TaskTypesRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<TaskTypesRepository>(
      () => TaskTypesRepositoryImpl(sl<TaskTypesRemoteDataSource>()),
    )
    // client
    ..registerLazySingleton<ClientsRemoteDataSource>(
      () => ClientsRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<ClientsRepository>(
      () => ClientsRepositoryImpl(sl<ClientsRemoteDataSource>()),
    )
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
    ..registerFactory(() => TasksCubit(sl<GetTasksUseCase>()))
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
    ..registerFactory(() => ActivityDetailCubit(sl<GetActivityDetailUsecase>()))
    /// Events
    ..registerLazySingleton<EventsRemoteDataSource>(
      () => EventsRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<EventsRepository>(
      () => EventsRepositoryImpl(sl<EventsRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetEventsUsecase(sl<EventsRepository>()))
    ..registerFactory(() => EventsCubit(sl<GetEventsUsecase>()))
    /// Event Detail
    ..registerLazySingleton<EventDetailRemoteDataSource>(
      () => EventDetailRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<EventDetailRepository>(
      () => EventDetailRepositoryImpl(sl<EventDetailRemoteDataSource>()),
    )
    ..registerLazySingleton(() => GetEventDetailUsecase(sl<EventDetailRepository>()))
    ..registerFactory(() => EventDetailCubit(sl<GetEventDetailUsecase>()))
    /// Create Task
    ..registerLazySingleton<CreateTaskRemoteDataSource>(
      () => CreateTaskRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<CreateTaskRepository>(
      () => CreateTaskRepositoryImpl(sl<CreateTaskRemoteDataSource>()),
    )
    ..registerLazySingleton(() => CreateTaskUsecase(sl<CreateTaskRepository>()))
    ..registerFactory(() => CreateTaskCubit(sl<CreateTaskUsecase>()))
    /// Create Event
    ..registerLazySingleton<CreateEventRemoteDataSource>(
      () => CreateEventRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<CreateEventRepository>(
      () => CreateEventRepositoryImpl(sl<CreateEventRemoteDataSource>()),
    )
    ..registerLazySingleton(() => CreateEventUsecase(sl<CreateEventRepository>()))
    ..registerFactory(() => CreateEventCubit(sl<CreateEventUsecase>()))
    /// Users
    ..registerLazySingleton<UsersRemoteDataSource>(() => UsersRemoteDataSourceImpl(sl<DioClient>()))
    ..registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl<UsersRemoteDataSource>()))
    ..registerLazySingleton(() => GetUsersUsecase(sl<UsersRepository>()))
    // ..registerFactory(() => CreateEventCubit(sl<CreateEventUsecase>()));
    /// Delete event
    ..registerLazySingleton<DeleteEventRemoteDataSource>(
      () => DeleteEventRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<DeleteEventRepository>(
      () => DeleteEventRepositoryImpl(sl<DeleteEventRemoteDataSource>()),
    )
    ..registerLazySingleton(() => DeleteEventUsecase(sl<DeleteEventRepository>()))
    ..registerFactory(() => DeleteEventCubit(sl<DeleteEventUsecase>()))
    /// Start activity
    ..registerLazySingleton<StartActivityRemoteDataSource>(
      () => StartActivityRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<StartActivityRepository>(
      () => StartActivityRepositoryImpl(sl<StartActivityRemoteDataSource>()),
    )
    ..registerLazySingleton(() => StartActivityUsecase(sl<StartActivityRepository>()))
    ..registerFactory(() => ActivityStartCubit(sl<StartActivityUsecase>()))
    /// active activity
    ..registerFactory<ActiveActivityRemoteDataSource>(
      () => ActiveActivityRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerFactory<ActiveActivityRepository>(
      () => ActiveActivityRepositoryImpl(sl<ActiveActivityRemoteDataSource>()),
    )
    ..registerFactory(() => GetActiveActivity(sl<ActiveActivityRepository>()))
    ..registerFactory(() => ActivityStatusCubit(sl<GetActiveActivity>()))
    /// Activity types
    ..registerLazySingleton<ActivityTypesRemoteDataSource>(
      () => ActivityTypesRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerLazySingleton<ActivityTypesRepository>(
      () => ActivityTypesRepositoryImpl(sl<ActivityTypesRemoteDataSource>()),
    )
    /// update event
    ..registerFactory<UpdateEventRemoteDataSource>(
      () => UpdateEventRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerFactory<UpdateEventRepository>(
      () => UpdateEventRepositoryImpl(sl<UpdateEventRemoteDataSource>()),
    )
    ..registerFactory(() => UpdateEventUsecase(sl<UpdateEventRepository>()))
    ..registerFactory(() => UpdateEventCubit(sl<UpdateEventUsecase>()))
    /// Stop activity
    ..registerFactory<StopActivityRemoteDataSource>(
      () => StopActivityRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerFactory<StopActivityRepository>(
      () => StopActivityRepositoryImpl(sl<StopActivityRemoteDataSource>()),
    )
    ..registerFactory(() => StopActivityUsecase(sl<StopActivityRepository>()))
    ..registerFactory(() => StopActivityCubit(sl<StopActivityUsecase>()))
    /// Check attendee status
    ..registerFactory<AttendeeStatusRemoteDataSource>(
      () => AttendeeStatusRemoteDataSourceImpl(sl<DioClient>()),
    )
    ..registerFactory<AttendeeStatusRepository>(
      () => AttendeeStatusRepositoryImpl(sl<AttendeeStatusRemoteDataSource>()),
    )
    ..registerFactory(() => ArriveAttendeeUsecase(sl<AttendeeStatusRepository>()))
    ..registerFactory(() => LeaveAttendeeUsecase(sl<AttendeeStatusRepository>()))
    ..registerFactory(() => CheckAttendeeStatusUsecase(sl<AttendeeStatusRepository>()))
    ..registerFactory(
      () => AttendeeCubit(
        sl<CheckAttendeeStatusUsecase>(),
        sl<ArriveAttendeeUsecase>(),
        sl<LeaveAttendeeUsecase>(),
      ),
    );
}
