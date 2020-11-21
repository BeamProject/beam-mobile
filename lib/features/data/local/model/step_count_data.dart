import 'package:intl/intl.dart';

class OngoingDailyStepCountData {
  static const COLUMN_ID = "id";
  static const COLUMN_STEP_COUNT_AT_START_OF_THE_DAY = "step_count_at_start_of_the_day";
  static const COLUMN_STEP_COUNT_AT_LAST_MEASUREMENT = "step_count_at_last_measurement";
  static const COLUMN_DAY_OF_MEASUREMENT = "day_of_measurement";

  final int id;
  final int stepCountAtStartOfTheDay;
  final int stepCountAtLastMeasurement;
  final String dayOfMeasurement;

  OngoingDailyStepCountData._({this.id, this.stepCountAtStartOfTheDay, this.stepCountAtLastMeasurement, this.dayOfMeasurement});

  OngoingDailyStepCountData({this.stepCountAtStartOfTheDay, this.stepCountAtLastMeasurement, DateTime dayOfMeasurement})
      : id = 0,
        dayOfMeasurement = new DateFormat('yyyy-MM-dd').format(dayOfMeasurement);

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_STEP_COUNT_AT_START_OF_THE_DAY: stepCountAtStartOfTheDay,
      COLUMN_STEP_COUNT_AT_LAST_MEASUREMENT: stepCountAtLastMeasurement,
      COLUMN_DAY_OF_MEASUREMENT: dayOfMeasurement
    };
  }

  factory OngoingDailyStepCountData.fromMap(Map<String, dynamic> map) {
    return OngoingDailyStepCountData._(
        id: map[COLUMN_ID],
        stepCountAtStartOfTheDay: map[COLUMN_STEP_COUNT_AT_START_OF_THE_DAY],
        stepCountAtLastMeasurement: map[COLUMN_STEP_COUNT_AT_LAST_MEASUREMENT],
        dayOfMeasurement: map[COLUMN_DAY_OF_MEASUREMENT]);
  }
}
