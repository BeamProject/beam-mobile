import 'dart:collection';

import 'package:beam/features/data/datasources/profile_local_data_source.dart';
import 'package:beam/features/domain/repositories/profile_repository.dart';
import 'package:beam/features/domain/usecases/get_donation_goal.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileLocalDataSource _profileLocalDataSource;
  final _donationGoalStreamControllers =
      HashMap<Period, BehaviorSubject<DonationGoal?>>();

  ProfileRepositoryImpl(this._profileLocalDataSource);

  @override
  Future<int> getDailyStepsGoal() async {
    return (await _profileLocalDataSource.getDailyStepsGoal()) ?? 0;
  }

  @override
  Stream<DonationGoal?> observeDonationGoal(Period period) async* {
    var streamController = _donationGoalStreamControllers[period];
    if (streamController == null) {
      streamController = BehaviorSubject<DonationGoal?>();
      _donationGoalStreamControllers[period] = streamController;
      streamController.value =
          await _profileLocalDataSource.getDonationGoal(period);
    }
    yield* streamController.stream;
  }

  @override
  Future<void> setDonationGoal(DonationGoal donationGoal) {
    final streamController =
        _donationGoalStreamControllers[donationGoal.period];
    if (streamController != null) {
      streamController.value = donationGoal;
    }
    return _profileLocalDataSource.setDonationGoal(donationGoal);
  }
}
