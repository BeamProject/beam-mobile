import 'package:beam/features/domain/entities/steps/ongoing_daily_step_count.dart';
import 'package:beam/features/domain/entities/steps/step_tracker.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartStepTracking {
  final StepTracker _stepTracker;

  StartStepTracking(this._stepTracker);

  Stream<StepCountEvent> call() {
    return _stepTracker.startStepTracking();
  }
}
