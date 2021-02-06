import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMonthlyDonationGoal {
  final ProfileRepository _profileRepository;

  GetMonthlyDonationGoal(this._profileRepository);

  Future<int> call() {
    return _profileRepository.getMonthlyDonationGoal();
  }
}
