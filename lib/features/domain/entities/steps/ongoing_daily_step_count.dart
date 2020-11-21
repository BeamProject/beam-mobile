import 'package:equatable/equatable.dart';

/// A class representing an ongoing daily step count based on two values:
///  1. Step count at the first measurement of the day.
///  2. Step count at the last measurement of the day.
///
/// This class offers factory methods which create a new instance based on the latest measurement.
/// Whenever the latest measurement was taken on a different day than the original instance,
/// the latest measurement will be used to define the first measurement of the new day.
class OngoingDailyStepCount extends Equatable {
  final DateTime dayOfMeasurement;
  final int stepCountAtStartOfTheDay;
  final int stepCountAtLastMeasurement;
  int get totalSteps => stepCountAtLastMeasurement - stepCountAtStartOfTheDay;

  OngoingDailyStepCount(
      {this.dayOfMeasurement,
      this.stepCountAtStartOfTheDay,
      this.stepCountAtLastMeasurement});

  factory OngoingDailyStepCount.createNewFromStepCountEvent(
      StepCountEvent stepCountEvent) {
    return OngoingDailyStepCount(
        dayOfMeasurement: stepCountEvent.dayOfMeasurement,
        stepCountAtLastMeasurement: stepCountEvent.steps,
        stepCountAtStartOfTheDay: stepCountEvent.steps);
  }

  OngoingDailyStepCount createWithNewStepCountEvent(
      StepCountEvent stepCountEvent) {
    final newDayOfMeasurement = stepCountEvent.dayOfMeasurement;
    final newStepsMeasurement = stepCountEvent.steps;
    if (newDayOfMeasurement.isSameDayAs(dayOfMeasurement) ||
        // This can happen when the clock changes backwards.
        newDayOfMeasurement.isBefore(dayOfMeasurement)) {
      return OngoingDailyStepCount(
        dayOfMeasurement: dayOfMeasurement,
        stepCountAtStartOfTheDay: stepCountAtStartOfTheDay,
        stepCountAtLastMeasurement: newStepsMeasurement,
      );
    }

    if (newDayOfMeasurement.isAfter(dayOfMeasurement)) {
      return OngoingDailyStepCount(
          dayOfMeasurement: newDayOfMeasurement,
          stepCountAtStartOfTheDay: newStepsMeasurement,
          stepCountAtLastMeasurement: newStepsMeasurement);
    }

    throw Exception(
        "newDayOfMeasurement is neither before, same as nor after dayOfMeasurement");
  }

  bool isDayOfMeasurementAfter(OngoingDailyStepCount other) {
    return !dayOfMeasurement.isSameDayAs(other.dayOfMeasurement) &&
        dayOfMeasurement.isAfter(other.dayOfMeasurement);
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

class StepCountEvent extends Equatable {
  final int steps;
  final DateTime dayOfMeasurement;

  const StepCountEvent({this.steps, this.dayOfMeasurement});

  @override
  List<Object> get props => [
        steps,
        dayOfMeasurement.year,
        dayOfMeasurement.month,
        dayOfMeasurement.day,
      ];
}

extension DateOnlyComparator on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
