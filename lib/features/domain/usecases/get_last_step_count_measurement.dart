import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLastStepCountMeasurement {
  final StepsRepository _stepsRepository;

  GetLastStepCountMeasurement(this._stepsRepository);

  Future<DateTime?> call() {
    return _stepsRepository.getLastStepCountMeasurement();
  }
}
