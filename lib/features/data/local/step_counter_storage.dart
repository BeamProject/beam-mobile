import 'package:beam/features/data/datasources/steps/step_counter_local_data_source.dart';
import 'package:beam/features/domain/entities/steps/step_count.dart';
import 'package:injectable/injectable.dart';

@injectable
class StepCounterStorage implements StepCounterLocalDataSource {
  @override
  Future<StepCount> getLatestStepCount() {
    // TODO: implement getLatestStepCount
    throw UnimplementedError();
  }

  @override
  Future<void> updateStepCount(StepCount stepCount) {
    // TODO: implement updateStepCount
    throw UnimplementedError();
  }
  

}