package com.example.beam

import android.content.Context
import android.content.Intent
import android.util.Log
import dagger.hilt.android.qualifiers.ApplicationContext
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class StepCounterPlugin @Inject constructor(@ApplicationContext private val context: Context) :
        MethodChannel.MethodCallHandler, EventChannel.StreamHandler, FlutterPlugin {
    companion object {
        const val CHANNEL = "plugins.beam/step_counter_plugin"
        const val SERVICE_STATUS_CHANNEL = "plugins.beam/step_counter_service_status_plugin"
        const val TAG = "StepCounterPlugin"
    }

    @Inject
    lateinit var stepCounterServiceStatusProvider: StepCounterServiceStatusProvider
    private val isInitialized get() = stepCounterServiceStatusProvider.observeServiceStatus().value
    private lateinit var channel: MethodChannel
    private val pluginScope = CoroutineScope(Job() + Dispatchers.Main)
    private var serviceStatusCollectionJob: Job? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen")
        serviceStatusCollectionJob?.cancel()
        serviceStatusCollectionJob = stepCounterServiceStatusProvider.observeServiceStatus().onEach {
            Log.d(TAG, "onServicestatusChanged: $it")
            events!!.success(it)
        }.launchIn(pluginScope)
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        serviceStatusCollectionJob?.cancel()
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
                result.success(isInitialized)
            }
            else -> result.notImplemented()
        }
    }

    private fun initializeService(callbackHandle: Long) {
        if (isInitialized) {
            return
        }
        Intent(context, StepCountTrackerService::class.java).apply {
            putExtra(StepCountTrackerService.CALLBACK_HANDLE_EXTRA, callbackHandle)
        }.also { intent ->
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


    private fun stopObservingServiceStatus() {
        serviceStatusCollectionJob?.cancel()
        serviceStatusCollectionJob = null
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "On attached to engine")
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        EventChannel(binding.binaryMessenger, SERVICE_STATUS_CHANNEL).setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "On detached from engine")
        stopObservingServiceStatus()
    }
}