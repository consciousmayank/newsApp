class EnvironmentConfig {
  static const baseUrl = String.fromEnvironment('BASE_URL',
      defaultValue: 'https://newsapi.org/v2');
  static const showLogs =
      bool.fromEnvironment('SHOW_LOGS', defaultValue: false);
  static const apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
}
