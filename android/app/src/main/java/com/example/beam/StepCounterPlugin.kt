package com.example.beam

import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class StepCounterPlugin constructor(private val context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        const val CHANNEL = "plugins.beam/step_counter_plugin"
        const val CALLBACK_DISPATCHER_HANDLE_KEY =
                "step_counter_callback_dispatcher_handle_key"
        const val SHARED_PREFS_KEY = "step_counter_plugin_cache"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments<ArrayList<*>>()
        when (call.method) {
            "StepCounterService.initializeService" -> {
                initializeService(args[0] as Long)
                result.success(true)
            }
            "StepCounterService.stopService" -> {
                stopService()
                result.success(true)
            }
            "StepCounterService.isInitialized" -> {
                result.success(isInitialized())
            }
            else -> result.notImplemented()
        }
    }

    private fun initializeService(callbackHandle: Long) {
        context.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE)
                .edit()
                .putLong(CALLBACK_DISPATCHER_HANDLE_KEY, callbackHandle)
                .apply()

        Intent(context, StepCountTrackerService::class.java).also { intent ->
            context.startService(intent)
        }
    }

    private fun stopService() {
        Intent(context, StepCountTrackerService::class.java).apply {
            action = StepCountTrackerService.ACTION_STOP_FOREGROUND
        }.also { intent ->
            context.startService(intent)
        }
    }

    private fun isInitialized(): Boolean = StepCountTrackerService.isRunning
}