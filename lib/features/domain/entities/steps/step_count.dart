import 'package:equatable/equatable.dart';

class StepCount extends Equatable {
  final DateTime dayOfMeasurement;
  final int stepCountAtStartOfTheDay;
  final int stepCountAtLastMeasurement;
  int get totalDailySteps =>
      stepCountAtLastMeasurement - stepCountAtStartOfTheDay;

  StepCount(
      {this.dayOfMeasurement,
      this.stepCountAtStartOfTheDay,
      this.stepCountAtLastMeasurement});

  factory StepCount.createNewFromMeasurement(DateTime dayOfMeasurement,
      int steps) {
    return StepCount(
        dayOfMeasurement: dayOfMeasurement,
        stepCountAtLastMeasurement: steps,
        stepCountAtStartOfTheDay: steps);
  }

  StepCount createWithNewMeasurement(
      DateTime newDayOfMeasurement, int newStepsMeasurement) {
    if (newDayOfMeasurement.isSameDayAs(dayOfMeasurement) ||
        // This can happen when the clock changes backwards.
        newDayOfMeasurement.isBefore(dayOfMeasurement)) {
      return StepCount(
        dayOfMeasurement: dayOfMeasurement,
        stepCountAtStartOfTheDay: stepCountAtStartOfTheDay,
        stepCountAtLastMeasurement: newStepsMeasurement,
      );
    }

    if (newDayOfMeasurement.isAfter(dayOfMeasurement)) {
      return StepCount(
          dayOfMeasurement: newDayOfMeasurement,
          stepCountAtStartOfTheDay: newStepsMeasurement,
          stepCountAtLastMeasurement: newStepsMeasurement);
    }

    throw Exception(
        "newDayOfMeasurement is neither before, same as nor after dayOfMeasurement");
  }

  @override
  List<Object> get props => [
        dayOfMeasurement.year,
        dayOfMeasurement.month,
        dayOfMeasurement.day,
        stepCountAtLastMeasurement,
        stepCountAtStartOfTheDay
  ];
}

extension DateOnlyComparator on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
