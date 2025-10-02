class ApiUrls {
  static const baseURL = 'https://anderson-api.w2w.uz/';
  // static const baseURL = 'https://billing-api.vl-legal.uz/';
  static const apiV = 'api/v1/mobile/';

  /// Auth
  static const login = '${apiV}auth/login';
  static const renewAccess = '${apiV}auth/renew-access';
  static const profile = '${apiV}users/profile';

  /// Attendees
  static const attendeeStatus = '${apiV}attendees/active';
  static const arrive = '${apiV}attendees/arrive';
  static const leave = '${apiV}attendees/leave';

  /// Tasks
  static const tasks = '${apiV}tasks';
  static const createTask = '${apiV}tasks';
  static String taskDetail(int taskId) => '${apiV}tasks/$taskId';
  static String taskUpdate(int taskId) => '${apiV}tasks/$taskId';

  /// Task Types
  static const taskTypes = '${apiV}task-types';

  /// Matters
  static const matters = '${apiV}matters';

  /// Clients
  static const clients = '${apiV}clients';

  /// Activities
  static const activities = '${apiV}activities';
  static const activeActivity = '${apiV}activities/active';
  static const startActivity = '${apiV}activities/start';
  static String stopActivity(int activityId) => '${apiV}activities/stop/$activityId';
  static String activityDetail(int activityId) => '${apiV}activities/$activityId';

  /// Activity Types
  static const activityTypes = '${apiV}activity-types';

  /// Events
  static const events = '${apiV}events';
  static const createEvent = '${apiV}events';
  static String eventDetail(int eventId) => '${apiV}events/$eventId';
  static String deleteEvent(int eventId) => '${apiV}events/$eventId';
  static String eventUpdate(int eventId) => '${apiV}events/$eventId';

  /// Users
  static const users = '${apiV}users';

  /// Kpi
  static String kpiUser(int userId) => '${apiV}kpi/user/$userId';
  static const kpi = '${apiV}kpi';
  static const workload = '${apiV}reports/tasks/count-by-type';
}
