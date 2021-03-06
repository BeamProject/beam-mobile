import 'package:beam/features/data/datasources/settings_local_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SettingsStorage extends SettingsLocalDataSource {
  static const KEY_STEP_COUNTER_SERVICE_ENABLED =
      "is_step_counter_service_enabled";

  SharedPreferences __prefs;
  Future<SharedPreferences> get _prefs async {
    if (__prefs == null) {
      __prefs = await SharedPreferences.getInstance();
    }
    return __prefs;
  }

  @override
  Future<bool> isStepCounterServiceEnabled() async {
    return (await _prefs).getBool(KEY_STEP_COUNTER_SERVICE_ENABLED) ?? false;
  }

  @override
  Future<void> setStepCounterServiceEnabled(bool enabled) async {
    return (await _prefs)
        .setBool(KEY_STEP_COUNTER_SERVICE_ENABLED, enabled)
        .then((value) => null);
  }
}
