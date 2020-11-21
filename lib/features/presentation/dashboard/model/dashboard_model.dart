import 'dart:async';

import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/observe_step_count.dart';
import 'package:beam/features/domain/usecases/start_step_tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardModel extends ChangeNotifier {
  User _user;
  int _steps = 0;
  StreamSubscription<User> _userSubscription;
  StreamSubscription<DailyStepCount> _stepCounterSubscription;

  final StartStepTracking _startStepTracking;

  User get user => _user;
  int get steps => _steps;

  DashboardModel(ObserveUser observeUser, ObserveStepCount observeStepCount, this._startStepTracking) {
    _userSubscription = observeUser().listen((user) {
      _user = user;
      notifyListeners();
    });

    _userSubscription.onError((error) {
      _user = null;
      notifyListeners();
    });

    _stepCounterSubscription = observeStepCount().listen((stepCount) {
      _steps = stepCount.steps;
      notifyListeners();
    });
  }

  void onStartStepTrackingButtonPressed() {
    // FIXME: move this to a separate class that represents a foreground service
    _startStepTracking();

  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _stepCounterSubscription.cancel();
    super.dispose();
  }
}
