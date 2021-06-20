import 'package:beam/features/data/datasources/profile_local_data_source.dart';
import 'package:beam/features/domain/usecases/profile_interactor.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ProfileStorage extends ProfileLocalDataSource {
  static const KEY_DAILY_STEPS_GOAL = "daily_steps_goal";
  static const KEY_MONTHLY_DONATION_GOAL = "monthly_donation_goal";
  static const KEY_YEARLY_DONATION_GOAL = "yearly_donation_goal";

  Future<SharedPreferences> get _sharedPreferences {
    return SharedPreferences.getInstance();
  }

  @override
  Future<int?> getDailyStepsGoal() async {
    return (await _sharedPreferences).getInt(KEY_DAILY_STEPS_GOAL);
  }

  @override
  Future<void> setDailyStepsGoal(int steps) async {
    (await _sharedPreferences).setInt(KEY_DAILY_STEPS_GOAL, steps);
  }

  @override
  Future<DonationGoal?> getDonationGoal(Period period) async {
    int? amount;
    switch (period) {
      case Period.MONTHLY:
        amount = (await _sharedPreferences).getInt(KEY_MONTHLY_DONATION_GOAL);
        break;
      case Period.YEARLY:
        amount = (await _sharedPreferences).getInt(KEY_YEARLY_DONATION_GOAL);
        break;
    }
    if (amount == null) {
      return null;
    }
    return DonationGoal(amount: amount, period: period);
  }

  @override
  Future<void> setDonationGoal(DonationGoal donationGoal) async {
    switch (donationGoal.period) {
      case Period.MONTHLY:
        (await _sharedPreferences)
            .setInt(KEY_MONTHLY_DONATION_GOAL, donationGoal.amount);
        break;
      case Period.YEARLY:
        (await _sharedPreferences)
            .setInt(KEY_YEARLY_DONATION_GOAL, donationGoal.amount);
        break;
    }
  }
}
