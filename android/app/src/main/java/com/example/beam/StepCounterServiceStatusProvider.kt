package com.example.beam

import kotlinx.coroutines.flow.StateFlow

interface StepCounterServiceStatusProvider {
    fun observeServiceStatus(): StateFlow<Boolean>
}