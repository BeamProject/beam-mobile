class StepCount {
  final DateTime dayOfMeasurement;
  final int stepCountAtStartOfTheDay;
  final int stepCountAtLastMeasurement;
  int get totalDailySteps =>
      stepCountAtLastMeasurement - stepCountAtStartOfTheDay;

  StepCount._(
      {this.dayOfMeasurement,
      this.stepCountAtStartOfTheDay,
      this.stepCountAtLastMeasurement});

  StepCount({this.dayOfMeasurement, int steps})
      : this.stepCountAtStartOfTheDay = steps,
        this.stepCountAtLastMeasurement = steps;

  StepCount createWithNewMeasurement(
      DateTime newDayOfMeasurement, int newStepsMeasurement) {
    if (newDayOfMeasurement.isSameDayAs(dayOfMeasurement) ||
        // This can happen when the clock changes backwards.
        newDayOfMeasurement.isBefore(dayOfMeasurement)) {
      return StepCount._(
        dayOfMeasurement: dayOfMeasurement,
        stepCountAtStartOfTheDay: stepCountAtStartOfTheDay,
        stepCountAtLastMeasurement: newStepsMeasurement,
      );
    }

    if (newDayOfMeasurement.isAfter(dayOfMeasurement)) {
      return StepCount._(
          dayOfMeasurement: newDayOfMeasurement,
          stepCountAtStartOfTheDay: newStepsMeasurement,
          stepCountAtLastMeasurement: newStepsMeasurement);
    }

    throw Exception(
        "newDayOfMeasurement is neither before, same as nor after dayOfMeasurement");
  }
}

extension DateOnlyComparator on DateTime {
  bool isSameDayAs(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
