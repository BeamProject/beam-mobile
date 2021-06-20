import 'package:beam/features/domain/usecases/profile_interactor.dart';

abstract class ProfileRepository {
  Stream<DonationGoal?> observeDonationGoal(Period period);

  Future<void> setDonationGoal(DonationGoal donationGoal);

  Stream<int?> observeDailyStepsGoal();

  Future<void> setDailyStepsGoal(int steps);
}
