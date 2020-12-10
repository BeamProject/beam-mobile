import 'dart:async';
import 'dart:developer';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/observe_step_count.dart';
import 'package:beam/features/domain/usecases/step_counter_service_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardModel extends ChangeNotifier {
  User _user;
  int _steps = 0;
  StepTrackingState _stepTrackingState;

  StreamSubscription<User> _userSubscription;
  StreamSubscription<DailyStepCount> _stepCounterSubscription;
  StreamSubscription<bool> _stepTrackingStatusSubscription;

  final StepCounterServiceInteractor _stepCounterServiceInteractor;

  User get user => _user;
  int get steps => _steps;
  String get stepTrackingButtonText => _stepTrackingState?.buttonText ?? "";

  DashboardModel(ObserveUser observeUser, ObserveStepCount observeStepCount,
      this._stepCounterServiceInteractor) {
    _userSubscription = observeUser().listen((user) {
      _user = user;
      notifyListeners();
    });

    _userSubscription.onError((error) {
      _user = null;
      notifyListeners();
    });

    _stepCounterSubscription = observeStepCount().listen((stepCount) {
      _steps = stepCount?.steps ?? 0;
      notifyListeners();
    });

    _stepTrackingStatusSubscription = _stepCounterServiceInteractor
        .observeStepCounterStatus()
        .listen((isRunning) {
      if (isRunning) {
        _stepTrackingState = StepTrackingState.running();
      } else {
        _stepTrackingState = StepTrackingState.stopped();
      }
      notifyListeners();
    });
  }

  void onStepTrackingButtonPressed() async {
    if (_stepTrackingState.isRunning) {
      await _stepCounterServiceInteractor.stopStepCounter();
    } else {
      await _stepCounterServiceInteractor.startStepCounter();
    }
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _stepCounterSubscription.cancel();
    _stepTrackingStatusSubscription.cancel();
    super.dispose();
  }
}

class StepTrackingState {
  final bool isRunning;
  final String buttonText;

  StepTrackingState(this.isRunning, this.buttonText);

  factory StepTrackingState.running() {
    return StepTrackingState(true, "Stop tracking steps");
  }

  factory StepTrackingState.stopped() {
    return StepTrackingState(false, "Start tracking steps");
  }
}
