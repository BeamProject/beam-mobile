import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DonationGoalInteractor {
  final ProfileRepository _profileRepository;

  DonationGoalInteractor(this._profileRepository);

  Stream<DonationGoal?> observeDonationGoal(Period period) {
    return _profileRepository.observeDonationGoal(period);
  }

  Future<void> setDonationGoal(DonationGoal donationGoal) {
    return _profileRepository.setDonationGoal(donationGoal);
  }
}

class DonationGoal {
  final int amount;
  final Period period;

  const DonationGoal({required this.amount, required this.period});
}

enum Period { MONTHLY, YEARLY }
