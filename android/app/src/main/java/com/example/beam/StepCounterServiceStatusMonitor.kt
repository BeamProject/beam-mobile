package com.example.beam

import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ApplicationComponent
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class StepCounterServiceStatusMonitor @Inject constructor() : StepCounterServiceStatusProvider {
    val serviceStatus = MutableStateFlow(false)

    override fun observeServiceStatus(): StateFlow<Boolean> = serviceStatus
}

@Module
@InstallIn(ApplicationComponent::class)
abstract class StepCounterServiceStatusMonitorModule {
    @Binds
    abstract fun stepCounterServiceStatusProvider(
            stepCounterServiceStatusMonitor: StepCounterServiceStatusMonitor): StepCounterServiceStatusProvider
}