import 'dart:async';

import 'package:beam/features/domain/usecases/step_counter_service_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsModel extends ChangeNotifier {
  bool get isStepTrackerRunning => _isStepCounterServiceRunning;

  final StepCounterServiceInteractor _stepCounterServiceInteractor;
  late final StreamSubscription<bool> _serviceStatusSubscription;
  bool _isStepCounterServiceRunning = false;

  SettingsModel(this._stepCounterServiceInteractor) {
    _serviceStatusSubscription = _stepCounterServiceInteractor
        .observeStepCounterServiceStatus()
        .listen((isRunning) {
      _isStepCounterServiceRunning = isRunning;
      notifyListeners();
    });
  }

  void onStepCounterServiceStatusChanged(bool newValue) async {
    newValue == true
        ? await _stepCounterServiceInteractor.startStepCounter()
        : await _stepCounterServiceInteractor.stopStepCounter();
    _isStepCounterServiceRunning = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    _serviceStatusSubscription.cancel();
    super.dispose();
  }
}
