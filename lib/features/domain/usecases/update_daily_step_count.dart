import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateDailyStepCount {
  final StepsRepository _stepsRepository;

  UpdateDailyStepCount(this._stepsRepository);

  Future<void> call(DailyStepCount dailyStepCount) async {
    await _stepsRepository.updateDailyStepCount(dailyStepCount);
    return _stepsRepository
        .updateLastStepCountMeasurement(dailyStepCount.dayOfMeasurement);
  }
}
