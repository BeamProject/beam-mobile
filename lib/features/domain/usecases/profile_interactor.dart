import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileInteractor {
  final ProfileRepository _profileRepository;

  ProfileInteractor(this._profileRepository);

  Stream<DonationGoal?> observeDonationGoal(Period period) {
    return _profileRepository.observeDonationGoal(period);
  }

  Future<void> setDonationGoal(DonationGoal donationGoal) {
    return _profileRepository.setDonationGoal(donationGoal);
  }

  Stream<int?> observeDailyStepsGoal() {
    return _profileRepository.observeDailyStepsGoal();
  }

  Future<void> setDailyStepsGoal(int steps) {
    return _profileRepository.setDailyStepsGoal(steps);
  }
}

class DonationGoal {
  final int amount;
  final Period period;

  const DonationGoal({required this.amount, required this.period});
}

enum Period { MONTHLY, YEARLY }
