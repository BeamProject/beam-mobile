import 'dart:async';

import 'package:beam/features/domain/usecases/profile_interactor.dart';
import 'package:beam/features/domain/usecases/step_counter_service_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsModel extends ChangeNotifier {
  bool get isStepTrackerRunning => _isStepCounterServiceRunning;
  int get monthlyDonationGoal => _monthlyDonationGoal;
  int get dailyStepsGoal => _dailyStepsGoal;

  final StepCounterServiceInteractor _stepCounterServiceInteractor;
  final ProfileInteractor _profileInteractor;
  late final StreamSubscription<bool> _serviceStatusSubscription;
  late final StreamSubscription<DonationGoal?> _donationGoalStreamSubscription;
  late final StreamSubscription<int?> _dailyStepsGoalStreamSubscription;
  bool _isStepCounterServiceRunning = false;
  int _monthlyDonationGoal = 0;
  int _dailyStepsGoal = 0;

  SettingsModel(this._stepCounterServiceInteractor, this._profileInteractor) {
    _serviceStatusSubscription = _stepCounterServiceInteractor
        .observeStepCounterServiceStatus()
        .listen((isRunning) {
      _isStepCounterServiceRunning = isRunning;
      notifyListeners();
    });
    _donationGoalStreamSubscription = _profileInteractor
        .observeDonationGoal(Period.MONTHLY)
        .listen((donationGoal) {
      _monthlyDonationGoal = donationGoal?.amount ?? 0;
      notifyListeners();
    });
    _dailyStepsGoalStreamSubscription =
        _profileInteractor.observeDailyStepsGoal().listen((stepsGoal) {
      _dailyStepsGoal = stepsGoal ?? 0;
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

  void onMonthlyDonationGoalChanged(int newValue) async {
    _monthlyDonationGoal = newValue;
    await _profileInteractor.setDonationGoal(
        DonationGoal(amount: newValue, period: Period.MONTHLY));
    notifyListeners();
  }

  void onStepsGoalChanged(int newValue) async {
    _dailyStepsGoal = newValue;
    await _profileInteractor.setDailyStepsGoal(newValue);
    notifyListeners();
  }

  @override
  void dispose() {
    _serviceStatusSubscription.cancel();
    _donationGoalStreamSubscription.cancel();
    _dailyStepsGoalStreamSubscription.cancel();
    super.dispose();
  }
}
