import 'dart:async';

import 'package:beam/features/domain/entities/steps/step_count.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/observe_step_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardModel extends ChangeNotifier {
  User _user;
  int _steps = 0;
  StreamSubscription<User> _userSubscription;
  StreamSubscription<StepCount> _stepCounterSubscription;

  User get user => _user;
  int get steps => _steps;

  DashboardModel(ObserveUser observeUser, ObserveStepCounter observeStepCounter) {
    _userSubscription = observeUser().listen((user) {
      _user = user;
      notifyListeners();
    });

    _userSubscription.onError((error) {
      _user = null;
      notifyListeners();
    });

    _stepCounterSubscription = observeStepCounter().listen((stepCount) {
      _steps = stepCount.totalDailySteps;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _stepCounterSubscription.cancel();
    super.dispose();
  }
}
