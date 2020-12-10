package com.example.beam

import androidx.annotation.NonNull
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.android.EntryPointAccessors
import dagger.hilt.android.components.ApplicationComponent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(EntryPointAccessors.fromApplication(
                context, StepCounterPluginEntryPoint::class.java).stepCounterPlugin())
    }

    @EntryPoint
    @InstallIn(ApplicationComponent::class)
    interface StepCounterPluginEntryPoint {
        fun stepCounterPlugin(): StepCounterPlugin
    }

}
