import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDailyStepCountRange {
  final StepsRepository _stepsRepository;

  GetDailyStepCountRange(this._stepsRepository);

  Future<List<DailyStepCount>> call(DateTime from, DateTime to) {
    return _stepsRepository.getDailyStepCountRange(from, to);
  }
}
