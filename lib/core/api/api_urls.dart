import 'package:andersen/core/config/env_config.dart';

class ApiUrls {
  /// Base URL loaded from environment
  static String get baseURL => EnvConfig.baseUrl;

  /// API version path
  static String get apiV => EnvConfig.apiVersion;

  /// Auth
  static String get login => '${apiV}auth/login';
  static String get renewAccess => '${apiV}auth/renew-access';
  static String get profile => '${apiV}users/profile';

  /// Attendees
  static String get attendeeStatus => '${apiV}attendees/active';
  static String get arrive => '${apiV}attendees/arrive';
  static String get leave => '${apiV}attendees/leave';

  /// Tasks
  static String get tasks => '${apiV}tasks';
  static String get createTask => '${apiV}tasks';

  static String taskDetail(int taskId) => '${apiV}tasks/$taskId';

  static String taskUpdate(int taskId) => '${apiV}tasks/$taskId';

  /// Task Types
  static String get taskTypes => '${apiV}task-types';

  /// Matters
  static String get matters => '${apiV}matters';

  /// Clients
  static String get clients => '${apiV}clients';

  /// Activities
  static String get activities => '${apiV}activities';
  static String get activeActivity => '${apiV}activities/active';
  static String get startActivity => '${apiV}activities/start';

  static String stopActivity(int activityId) => '${apiV}activities/stop/$activityId';

  static String activityDetail(int activityId) => '${apiV}activities/$activityId';

  /// Activity Types
  static String get activityTypes => '${apiV}activity-types';

  /// Events
  static String get events => '${apiV}events';
  static String get createEvent => '${apiV}events';

  static String eventDetail(int eventId) => '${apiV}events/$eventId';

  static String deleteEvent(int eventId) => '${apiV}events/$eventId';

  static String eventUpdate(int eventId) => '${apiV}events/$eventId';

  /// Users
  static String get users => '${apiV}users';

  /// Kpi
  static String kpiUser(int userId) => '${apiV}kpi/user/$userId';
  static String get kpi => '${apiV}kpi';
  static String get workload => '${apiV}reports/tasks/count-by-type';
  static String get complaints => '${apiV}complaints';
}
