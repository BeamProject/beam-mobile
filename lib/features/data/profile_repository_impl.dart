import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileRepositoryImpl extends ProfileRepository {
  @override
  Future<int> getDailyStepsGoal() {
    // TODO: implement getDailyStepsGoal
    return Future.value(5200);
  }

  @override
  Future<int> getMonthlyDonationGoal() {
    // TODO: implement getMonthlyDonationGoal
    return Future.value(50);
  }

}
