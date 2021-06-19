import 'dart:async';

import 'package:beam/features/domain/usecases/get_donation_goal.dart';
import 'package:beam/features/domain/usecases/step_counter_service_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsModel extends ChangeNotifier {
  bool get isStepTrackerRunning => _isStepCounterServiceRunning;
  int get monthlyDonationGoal => _monthlyDonationGoal;

  final StepCounterServiceInteractor _stepCounterServiceInteractor;
  final DonationGoalInteractor _donationGoalInteractor;
  late final StreamSubscription<bool> _serviceStatusSubscription;
  bool _isStepCounterServiceRunning = false;
  int _monthlyDonationGoal = 0;

  SettingsModel(
      this._stepCounterServiceInteractor, this._donationGoalInteractor) {
    _serviceStatusSubscription = _stepCounterServiceInteractor
        .observeStepCounterServiceStatus()
        .listen((isRunning) {
      _isStepCounterServiceRunning = isRunning;
      notifyListeners();
    });
    _donationGoalInteractor
        .observeDonationGoal(Period.MONTHLY)
        .listen((donationGoal) {
      _monthlyDonationGoal = donationGoal?.amount ?? 0;
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
    await _donationGoalInteractor.setDonationGoal(
        DonationGoal(amount: newValue, period: Period.MONTHLY));
    notifyListeners();
  }

  @override
  void dispose() {
    _serviceStatusSubscription.cancel();
    super.dispose();
  }
}
