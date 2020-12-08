import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDailyStepCount {
  final StepsRepository _stepsRepository;

  GetDailyStepCount(this._stepsRepository);

  Future<DailyStepCount> call(DateTime dayOfMeasurement) {
    return _stepsRepository.getDailyStepCount(dayOfMeasurement);
  }
}
