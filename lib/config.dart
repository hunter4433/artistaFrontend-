// lib/config.dart

class Config {
  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Config._internal();

  final String apiDomain = "http://52.66.8.103/api";

  String get baseDomain => apiDomain.replaceFirst('/api', '');
}
