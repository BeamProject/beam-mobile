import 'package:beam/common/di/config.dart';
import 'package:beam/features/data/local/settings_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    configureDependencies(injectable.Environment.test);
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    getIt.reset();
  });

  test('isStepCounterServiceEnabled', () {
    final settingsStorage = getIt<SettingsStorage>();

    expect(settingsStorage.isStepCounterServiceEnabled(), completion(false));
  });

  test('setStepCounterServiceEnabled', () async {
    final settingsStorage = getIt<SettingsStorage>();

    await settingsStorage.setStepCounterServiceEnabled(true);

    expect(settingsStorage.isStepCounterServiceEnabled(), completion(true));
  });
}
