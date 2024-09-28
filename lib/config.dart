// lib/config.dart

class Config {
  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Config._internal();

  final String apiDomain = "http://52.66.243.26/api";

  String get baseDomain => apiDomain.replaceFirst('/api', '');
}
