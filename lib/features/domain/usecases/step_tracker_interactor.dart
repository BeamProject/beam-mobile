import 'package:beam/features/domain/entities/steps/step_tracker.dart';
import 'package:injectable/injectable.dart';

/// Interactor class to start and stop observing step events.
/// This interactor assumes that there already is a running step counter service
/// in the background.
///
/// This interactor should only be called by a background isolate which is triggered
/// when the step counter service is initialized.
///
/// Do not call this interactor from any widgets. There should be no need to add
/// extra calls to this interactor.
@injectable
class StepTrackerInteractor {
  final StepTracker _stepTracker;

  StepTrackerInteractor(this._stepTracker);

  Future<void> observeStepEvents() {
    return _stepTracker.observeStepEvents();
  }

  void stopObservingStepEvents() {
    _stepTracker.stopObservingStepEvents();
  }
}
