abstract class ProfileRepository {
  Future<int> getMonthlyDonationGoal();

  Future<int> getDailyStepsGoal();
}