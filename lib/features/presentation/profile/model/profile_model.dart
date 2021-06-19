import 'dart:async';
import 'dart:math';

import 'package:beam/features/domain/entities/payment.dart';
import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/entities/user.dart';
import 'package:beam/features/domain/usecases/get_current_user.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count_range.dart';
import 'package:beam/features/domain/usecases/get_daily_step_count_goal.dart';
import 'package:beam/features/domain/usecases/get_donation_goal.dart';
import 'package:beam/features/domain/usecases/payments_interactor.dart';
import 'package:beam/features/domain/usecases/observe_step_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

// TODO Consider changing this to a bloc
@injectable
class ProfileModel extends ChangeNotifier {
  User? _user;
  int _steps = 0;
  int _totalAmountOfPaymentsThisMonth = 0;
  int _monthlyDonationGoalPercentage = 0;
  int _monthlyDonationGoal = 0;
  int _dailyStepCountGoal = 0;

  // _weeklyStepCountList has a fixed length of 7 as it represents daily step count in a week
  // 0-th element represents Monday, 1-st - Tuesday, etc.
  List<int> _weeklyStepCountList = [];

  late final StreamSubscription<User?> _userSubscription;
  late final StreamSubscription<DailyStepCount?> _stepCounterSubscription;
  late final StreamSubscription<PaymentsProgressData>
      _paymentsProgressSubscription;

  User? get user => _user;

  int get steps => _steps;

  int get totalAmountOfPaymentsThisMonth => _totalAmountOfPaymentsThisMonth;

  int get monthlyDonationGoalPercentage => _monthlyDonationGoalPercentage;
  int get monthlyDonationGoal => _monthlyDonationGoal;

  int get dailyStepCountGoal => _dailyStepCountGoal;

  List<int> get weeklyStepCountList => _weeklyStepCountList;

  ProfileModel(
      ObserveUser observeUser,
      ObserveStepCount observeStepCount,
      PaymentsInteractor paymentsInteractor,
      DonationGoalInteractor donationGoalInteractor,
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
      final beginningOfToday = DateTime(today.year, today.month, today.day);
      final firstDayOfWeek = beginningOfToday
          .subtract(Duration(days: beginningOfToday.weekday - 1));
      final weeklyStepCountList =
          await getDailyStepCountRange(firstDayOfWeek, today);
      _weeklyStepCountList = List.generate(
          7,
          (index) => weeklyStepCountList
              .firstWhere(
                  (element) => element.dayOfMeasurement.weekday - 1 == index,
                  orElse: () => DailyStepCount(
                      steps: 0,
                      // This value is ignored so we can put whatever.
                      dayOfMeasurement: DateTime.now()))
              .steps);
      notifyListeners();
    });

    final today = DateTime.now();
    final beginningOfThisMonth = DateTime(today.year, today.month, 1);
    // It's safe to pass 13 as a month value.
    final endOfThisMonth = DateTime(today.year, today.month + 1, 0);
    _paymentsProgressSubscription = Rx.combineLatest2(
            paymentsInteractor.getPaymentsBetween(
                beginningOfThisMonth, endOfThisMonth),
            donationGoalInteractor.observeDonationGoal(Period.MONTHLY),
            (List<Payment> payments, DonationGoal? goal) =>
                PaymentsProgressData(payments, goal))
        .listen((paymentsProgressData) async {
      final payments = paymentsProgressData.payments;
      _totalAmountOfPaymentsThisMonth = payments.isNotEmpty
          ? payments
              .map((e) => e.amount)
              .reduce((value, amount) => value + amount)
          : 0;
      final int? goalAmount = paymentsProgressData.donationGoal?.amount;
      _monthlyDonationGoalPercentage = goalAmount != null
          ? min(
              100,
              (_totalAmountOfPaymentsThisMonth.toDouble() / goalAmount * 100)
                  .toInt())
          : 0;
      _monthlyDonationGoal = goalAmount != null ? goalAmount : 0;
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
    _paymentsProgressSubscription.cancel();
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

class PaymentsProgressData {
  final List<Payment> payments;
  final DonationGoal? donationGoal;

  PaymentsProgressData(this.payments, this.donationGoal);
}
