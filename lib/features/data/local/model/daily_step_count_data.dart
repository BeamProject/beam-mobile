import 'package:beam/features/domain/entities/steps/daily_step_count.dart';
import 'package:intl/intl.dart';

class DailyStepCountData {
  static const COLUMN_ID = "id";
  static const COLUMN_STEPS = "steps";
  static const COLUMN_DAY_OF_MEASUREMENT = "day_of_measurement";
  static final dateFormat = DateFormat('yyyy-MM-dd');

  final int id;
  final int steps;
  final String dayOfMeasurement;

  DailyStepCountData._({this.id, this.steps, this.dayOfMeasurement});

  DailyStepCountData(DailyStepCount dailyStepCount)
      : id = null,
        steps = dailyStepCount.steps,
        dayOfMeasurement =
            dateFormat.format(dailyStepCount.dayOfMeasurement.toUtc());

  Map<String, dynamic> toMap() {
    final map = {
      COLUMN_STEPS: steps,
      COLUMN_DAY_OF_MEASUREMENT: dayOfMeasurement
    };
    if (id != null) {
      map[COLUMN_ID] = id;
    }
    return map;
  }

  factory DailyStepCountData.fromMap(Map<String, dynamic> map) {
    return DailyStepCountData._(
        id: map[COLUMN_ID],
        steps: map[COLUMN_STEPS],
        dayOfMeasurement: map[COLUMN_DAY_OF_MEASUREMENT]);
  }

  DailyStepCount toDailyStepCount() {
    return DailyStepCount(
        steps: steps,
        dayOfMeasurement: dateFormat.parse(dayOfMeasurement).toUtc());
  }
}
