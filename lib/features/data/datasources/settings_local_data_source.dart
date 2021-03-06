abstract class SettingsLocalDataSource {
  Future<bool> isStepCounterServiceEnabled();

  Future<void> setStepCounterServiceEnabled(bool enabled);
}