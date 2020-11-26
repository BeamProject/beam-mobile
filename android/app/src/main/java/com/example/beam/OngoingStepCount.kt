package com.example.beam

import java.time.LocalDate

/**
 * A class representing an ongoing daily step count based on two values:
 * 1. Step count at the first measurement of the day.
 * 2. Step count at the last measurement of the day.
 *
 * This class offers factory methods which create a new instance based on the latest measurement.
 * Whenever the latest measurement was taken on a different day than the original instance,
 * the latest measurement will be used to define the first measurement of the new day.
 */
data class OngoingStepCount constructor(private val stepCountAtStartOfTheDay: Int,
                                        private val stepCountAtLastMeasurement: Int,
                                        private val dayOfMeasurement: LocalDate) {
    val totalSteps: Int
        get() = stepCountAtLastMeasurement - stepCountAtStartOfTheDay

    companion object Factory {
        fun createNewFromStepCountEvent(steps: Int, dayOfMeasurement: LocalDate): OngoingStepCount {
            return OngoingStepCount(steps, steps, dayOfMeasurement)
        }
    }

    fun createWithNewStepCountEvent(newStepsMeasurement: Int, newDayOfMeasurement: LocalDate):
            OngoingStepCount {
        if (newDayOfMeasurement.isEqual(dayOfMeasurement) ||
                // This can happen when the clock changes backwards.
                newDayOfMeasurement.isBefore(dayOfMeasurement)) {
            return OngoingStepCount(
                    stepCountAtStartOfTheDay,
                    newStepsMeasurement,
                    dayOfMeasurement
            )
        }

        if (newDayOfMeasurement.isAfter(dayOfMeasurement)) {
            return OngoingStepCount(
                    newStepsMeasurement,
                    newStepsMeasurement,
                    newDayOfMeasurement)
        }

        throw Exception(
                "newDayOfMeasurement is neither before, same as nor after dayOfMeasurement");
    }
}