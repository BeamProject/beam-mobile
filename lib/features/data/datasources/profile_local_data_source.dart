import 'package:beam/features/domain/usecases/get_donation_goal.dart';

abstract class ProfileLocalDataSource {
  Future<DonationGoal?> getDonationGoal(Period period);

  Future<void> setDonationGoal(DonationGoal donationGoal);

  Future<int?> getDailyStepsGoal();
}
