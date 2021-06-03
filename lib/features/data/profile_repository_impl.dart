import 'package:beam/features/data/datasources/profile_local_data_source.dart';
import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:beam/features/domain/usecases/get_donation_goal.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileLocalDataSource _profileLocalDataSource;

  ProfileRepositoryImpl(this._profileLocalDataSource);

  @override
  Future<int> getDailyStepsGoal() async {
    return (await _profileLocalDataSource.getDailyStepsGoal()) ?? 0;
  }

  @override
  Future<DonationGoal?> getDonationGoal(Period period) {
    return _profileLocalDataSource.getDonationGoal(period);
  }

  @override
  Future<void> setDonationGoal(DonationGoal donationGoal) {
    return _profileLocalDataSource.setDonationGoal(donationGoal);
  }
}
