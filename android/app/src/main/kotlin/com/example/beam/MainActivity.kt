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
    lateinit var stepCounterPlugin: StepCounterPlugin

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, StepCounterPlugin.CHANNEL)
        val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, StepCounterPlugin.SERVICE_STATUS_CHANNEL)
        stepCounterPlugin = EntryPointAccessors.fromApplication(context, StepCounterPluginEntryPoint::class.java).stepCounterPlugin()
        methodChannel.setMethodCallHandler(stepCounterPlugin)
        eventChannel.setStreamHandler(stepCounterPlugin)
        stepCounterPlugin.setChannel(methodChannel)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        stepCounterPlugin.dispose()
        super.cleanUpFlutterEngine(flutterEngine)
    }

    @EntryPoint
    @InstallIn(ApplicationComponent::class)
    interface StepCounterPluginEntryPoint {
        fun stepCounterPlugin(): StepCounterPlugin
    }

}
