import 'package:beam/features/domain/repositories/steps_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLastStepCountMeasurement {
  final StepsRepository _stepsRepository;

  UpdateLastStepCountMeasurement(this._stepsRepository);

  Future<void> call(DateTime dateTimeOfMeasurement) {
    return _stepsRepository
        .updateLastStepCountMeasurement(dateTimeOfMeasurement);
  }
}
