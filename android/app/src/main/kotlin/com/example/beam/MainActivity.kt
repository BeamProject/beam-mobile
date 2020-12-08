package com.example.beam

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var stepCounterPlugin: StepCounterPlugin

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, StepCounterPlugin.CHANNEL)
        stepCounterPlugin = StepCounterPlugin(this, methodChannel)
        methodChannel.setMethodCallHandler(stepCounterPlugin)
        stepCounterPlugin.bind()
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        stepCounterPlugin.unbind()
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
