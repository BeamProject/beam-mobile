package com.example.beam

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import dagger.hilt.android.qualifiers.ApplicationContext
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

// TODO: Refactor to be an actual FlutterPlugin. And call stopObserviceServiceStatus and unbind when detached
// from the engine.
class StepCounterPlugin @Inject constructor(@ApplicationContext private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    companion object {
        const val CHANNEL = "plugins.beam/step_counter_plugin"
        const val SERVICE_STATUS_CHANNEL = "plugins.beam/step_counter_service_status_plugin"
        const val CALLBACK_DISPATCHER_HANDLE_KEY =
                "step_counter_callback_dispatcher_handle_key"
        const val SHARED_PREFS_KEY = "step_counter_plugin_cache"
        const val TAG = "StepCounterPlugin"
    }

    private val pluginScope = CoroutineScope(Job() + Dispatchers.Main)
    private var serviceStatusCollectionJob: Job? = null
    private val isInitialized get() = stepCounterServiceStatusProvider.observeServiceStatus().value

    @Inject
    lateinit var stepCounterServiceStatusProvider: StepCounterServiceStatusProvider
    private lateinit var channel: MethodChannel

    fun setChannel(channel: MethodChannel) {
        this.channel = channel
    }

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

    fun dispose() {
        stopObservingServiceStatus()
    }

    private fun initializeService(callbackHandle: Long) {
        if (isInitialized) {
            return
        }
        // TODO: It shouldn't be necessary to store the callback in shared prefs. Pass it as part of the intent.
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


    private fun stopObservingServiceStatus() {
        serviceStatusCollectionJob?.cancel()
        serviceStatusCollectionJob = null
    }

}