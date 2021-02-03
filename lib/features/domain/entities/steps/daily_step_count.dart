import 'package:equatable/equatable.dart';

class DailyStepCount extends Equatable {
  final int steps;
  final DateTime dayOfMeasurement;

  DailyStepCount({this.steps, this.dayOfMeasurement});

  @override
  List<Object> get props => [steps, dayOfMeasurement];
}