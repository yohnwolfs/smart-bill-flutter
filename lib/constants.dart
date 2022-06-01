import 'package:sp_util/sp_util.dart';

class Config {
  Config._();

  static Config? _instance;

  factory Config() {
    return _instance ?? Config._();
  }

  String get server {
    final store = SpUtil.getString('serverUrl');
    return (store != null && store != '') ? store : "http://localhost:3000";
  }

  String get apiUrl => "$server/api";
}
