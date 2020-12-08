package com.example.beam

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

// TODO: Refactor to be an actual FlutterPlugin. And call stopObserviceServiceStatus and unbind when detached
// from the engine.
class StepCounterPlugin constructor(private val context: Context, private val channel: MethodChannel) : MethodChannel.MethodCallHandler {
    companion object {
        const val CHANNEL = "plugins.beam/step_counter_plugin"
        const val CALLBACK_DISPATCHER_HANDLE_KEY =
                "step_counter_callback_dispatcher_handle_key"
        const val SHARED_PREFS_KEY = "step_counter_plugin_cache"
        const val TAG = "StepCounterPlugin"
    }
    private val pluginScope = CoroutineScope(Job() + Dispatchers.Main)
    private var serviceStatusCollectionJob: Job? = null
    private var shouldUnbind = false

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            Log.d(TAG, "onServiceConnected")
            val binder = service as StepCountTrackerService.LocalBinder
            serviceStatusCollectionJob?.cancel()
            serviceStatusCollectionJob = binder.getService().serviceStatus.onEach {
                channel.invokeMethod("onServiceStatusChanged", it)
            }.launchIn(pluginScope)
        }

        override fun onServiceDisconnected(arg0: ComponentName) {
            Log.d(TAG, "onServiceDisconnected")
        }
    }

    fun bind() {
        doBindService()
    }

    // TODO: Call unbind from onengineDetached method
    fun unbind() {
        doUnbindService()
        stopObservingServiceStatus()
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
        if (isInitialized()) {
            return
        }
        // TODO: It shouldn't be necessary to store the callback in shared prefs. Pass it as part of the intent.
        context.getSharedPreferences(SHARED_PREFS_KEY, Context.MODE_PRIVATE)
                .edit()
                .putLong(CALLBACK_DISPATCHER_HANDLE_KEY, callbackHandle)
                .apply()

        Intent(context, StepCountTrackerService::class.java).also { intent ->
            context.startService(intent)
            doBindService()
        }
    }

    private fun stopService() {
        Intent(context, StepCountTrackerService::class.java).apply {
            action = StepCountTrackerService.ACTION_STOP_FOREGROUND
        }.also { intent ->
            context.startService(intent)
            doUnbindService()
        }
    }

    private fun stopObservingServiceStatus() {
        serviceStatusCollectionJob?.cancel()
        serviceStatusCollectionJob = null
    }

    private fun doBindService() {
        Intent(context, StepCountTrackerService::class.java).also { intent ->
            if (context.bindService(intent, connection, 0)) {
                shouldUnbind = true
            }
        }

    }

    private fun doUnbindService() {
        if (shouldUnbind) {
            context.unbindService(connection)
            shouldUnbind = false
        }
    }

    private fun isInitialized(): Boolean = StepCountTrackerService.isInitialized

}