import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count_range.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count_goal.dart';
import 'package:beam/features/domain/usecases/get_monthly_donation_goal.dart';
import 'package:beam/features/domain/usecases/payments_interactor.dart';
import 'package:beam/features/domain/usecases/observe_step_count.dart';
import 'package:beam/features/domain/usecases/step_counter_service_interactor.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

// TODO Consider changing this to a bloc
@injectable
class ProfileModel extends ChangeNotifier {
  User _user;
  int _steps = 0;
  StepTrackingState _stepTrackingState;
  int _totalAmountOfPaymentsThisMonth = 0;
  int _monthlyDonationGoalPercentage = 0;
  int _dailyStepCountGoal = 0;
  // _weeklyStepCountList has a fixed length of 7 as it represents daily step count in a week
  // 0-th element represents Monday, 1-st - Tuesday, etc.
  List<int> _weeklyStepCountList = [];

  StreamSubscription<User> _userSubscription;
  StreamSubscription<DailyStepCount> _stepCounterSubscription;
  StreamSubscription<bool> _stepTrackingStatusSubscription;
  StreamSubscription<List<Payment>> _paymentsSubscription;

  final StepCounterServiceInteractor _stepCounterServiceInteractor;

  User get user => _user;
  int get steps => _steps;
  int get totalAmountOfPaymentsThisMonth => _totalAmountOfPaymentsThisMonth;
  int get monthlyDonationGoalPercentage => _monthlyDonationGoalPercentage;
  int get dailyStepCountGoal => _dailyStepCountGoal;
  List<int> get weeklyStepCountList => _weeklyStepCountList;

  ProfileModel(
      ObserveUser observeUser,
      ObserveStepCount observeStepCount,
      this._stepCounterServiceInteractor,
      PaymentsInteractor paymentsInteractor,
      GetMonthlyDonationGoal getMonthlyDonationGoal,
      GetDailyStepCountRange getDailyStepCountRange,
      GetDailyStepCountGoal getDailyStepCountGoal) {
    _userSubscription = observeUser().listen((user) {
      _user = user;
      notifyListeners();
    });

    _userSubscription.onError((error) {
      _user = null;
      notifyListeners();
    });

    _stepCounterSubscription = observeStepCount().listen((stepCount) async {
      _steps = stepCount?.steps ?? 0;
      final today = DateTime.now();
      final beginningOfToday = DateTime.utc(today.year, today.month, today.day);
      final firstDayOfWeek = beginningOfToday
          .subtract(Duration(days: beginningOfToday.weekday - 1));
      final weeklyStepCountList =
          await getDailyStepCountRange(firstDayOfWeek, today);
      _weeklyStepCountList = List.generate(
          7,
          (index) =>
              weeklyStepCountList
                  .firstWhere(
                      (element) =>
                          element.dayOfMeasurement.weekday - 1 == index,
                      orElse: () => null)
                  ?.steps ??
              0);
      notifyListeners();
    });

    _stepTrackingStatusSubscription = _stepCounterServiceInteractor
        .observeStepCounterServiceStatus()
        .listen((isRunning) {
      if (isRunning) {
        _stepTrackingState = StepTrackingState.running();
      } else {
        _stepTrackingState = StepTrackingState.stopped();
      }
      notifyListeners();
    });

    final today = DateTime.now();
    final startDate = DateTime.utc(today.year, today.month, 1);
    // It's safe to pass 13 as a month value.
    final endDate = DateTime.utc(today.year, today.month + 1, 0);
    _paymentsSubscription = paymentsInteractor
        .getPaymentsBetween(startDate, endDate)
        .listen((payments) async {
      _totalAmountOfPaymentsThisMonth = payments
          .map((e) => e.amount)
          .reduce((value, amount) => value + amount);
      final int goal = await getMonthlyDonationGoal();
      _monthlyDonationGoalPercentage = min(100,
          (_totalAmountOfPaymentsThisMonth.toDouble() / goal * 100).toInt());
      notifyListeners();
    });

    getDailyStepCountGoal().then((value) {
      _dailyStepCountGoal = value;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    _stepCounterSubscription.cancel();
    _stepTrackingStatusSubscription.cancel();
    _paymentsSubscription.cancel();
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
