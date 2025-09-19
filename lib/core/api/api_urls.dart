class ApiUrls {
  static const baseURL = 'https://anderson-api.w2w.uz/';
  static const apiV = 'api/v1/mobile/';

  /// Auth
  static const login = '${apiV}auth/login';
  static const profile = '${apiV}users/profile';
  static const attendeeStatus = '${apiV}attendees/active';

  /// Tasks
  static const tasks = '${apiV}tasks';
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
  static String activityDetail(int activityId) => '${apiV}activities/$activityId';

  /// Events
  static const events = '${apiV}events';
}
