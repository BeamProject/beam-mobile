import 'package:beam/features/domain/usecases/profile_interactor.dart';

abstract class ProfileLocalDataSource {
  Future<DonationGoal?> getDonationGoal(Period period);

  Future<void> setDonationGoal(DonationGoal donationGoal);

  Future<int?> getDailyStepsGoal();

  Future<void> setDailyStepsGoal(int steps);
}
