import 'package:intl/intl.dart';

class StepCountData {
  static const COLUMN_ID = "id";
  static const COLUMN_STEPS = "steps";
  static const COLUMN_DAY_OF_MEASUREMENT = "day_of_measurement";

  final int id;
  final int steps;
  final String dayOfMeasurement;

  StepCountData._({this.id, this.steps, this.dayOfMeasurement});

  StepCountData({this.steps, DateTime dayOfMeasurement})
      : id = 0,
        dayOfMeasurement = new DateFormat('yyyy-MM-dd').format(dayOfMeasurement);

  Map<String, dynamic> toMap() {
    return {
      COLUMN_ID: id,
      COLUMN_STEPS: steps,
      COLUMN_DAY_OF_MEASUREMENT: dayOfMeasurement
    };
  }

  factory StepCountData.fromMap(Map<String, dynamic> map) {
    return StepCountData._(
        id: map[COLUMN_ID],
        steps: map[COLUMN_STEPS],
        dayOfMeasurement: map[COLUMN_DAY_OF_MEASUREMENT]);
  }
}
