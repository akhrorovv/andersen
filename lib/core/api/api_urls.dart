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
}
