enum AppEnv { dev, staging, prod }

class AppConstants {
  AppConstants._();

  static const String _env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dummyjson.com',
  );

  static final AppEnv env = AppEnv.values.byName(_env);

  static bool get isProd => env == AppEnv.prod;
}