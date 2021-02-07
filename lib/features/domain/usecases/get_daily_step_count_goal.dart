import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDailyStepCountGoal {
  final ProfileRepository _profileRepository;

  GetDailyStepCountGoal(this._profileRepository);

  Future<int> call() {
    return _profileRepository.getDailyStepsGoal();
  }
}
