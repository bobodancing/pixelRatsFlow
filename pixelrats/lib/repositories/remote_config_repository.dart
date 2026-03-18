/// Abstract Remote Config interface.
abstract class RemoteConfigRepository {
  Future<void> initialize();
  int getInt(String key);
  double getDouble(String key);
  String getString(String key);
  bool getBool(String key);
}
