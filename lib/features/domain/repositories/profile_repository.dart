import 'package:beam/features/domain/usecases/get_donation_goal.dart';

abstract class ProfileRepository {
  Stream<DonationGoal?> observeDonationGoal(Period period);

  Future<void> setDonationGoal(DonationGoal donationGoal);

  Future<int> getDailyStepsGoal();
}
