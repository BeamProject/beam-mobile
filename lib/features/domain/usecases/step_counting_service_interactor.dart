import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:beam/features/domain/entities/steps/step_tracker.dart';
import 'package:beam/features/domain/repositories/step_counter_service.dart';
import 'package:injectable/injectable.dart';

@injectable
class StepCounterServiceInteractor {
  final StepCounterService _stepCounterService;

  StepCounterServiceInteractor(this._stepCounterService);

  Future<void> startStepTracking() {
    return _stepCounterService.startService();
  }

  Future<void> stopStepTracking() async {
    await _stepCounterService.stopService();
  }

  Stream<bool> observeStepTrackingStatus() {
    return _stepCounterService.observeServiceStatus();
  }
}
