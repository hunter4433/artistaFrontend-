// lib/config.dart

class Config {
  static final Config _instance = Config._internal();

  factory Config() {
    return _instance;
  }

  Config._internal();

  final String apiDomain = "http://3.7.253.12/api";

  String get baseDomain => apiDomain.replaceFirst('/api', '');
}
