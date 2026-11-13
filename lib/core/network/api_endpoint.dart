class ApiEndpoint {
  //auth
  static const String login = '/auth/userlogin';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  static String forgotPassword(String email) =>
      '/auth/forgotpassword?emailAddress=${Uri.encodeQueryComponent(email)}';
  static const String appList = '/app/list';
  static const String serviceList = '/app/servicelist';

  static String userById(String id) => '/userinfo/GetUserById/$id';

  static String prayerTimeByGPS(String lat, String long) =>
      '/v2/solat/gps/$lat/$long?year=2026&month=8';
}
