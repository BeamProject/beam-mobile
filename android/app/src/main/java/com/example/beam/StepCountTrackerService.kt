package com.example.beam

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.IMPORTANCE_LOW
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.util.Log
import dagger.hilt.android.AndroidEntryPoint
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterCallbackInformation
import io.flutter.view.FlutterMain
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject

@AndroidEntryPoint
@ExperimentalCoroutinesApi
class StepCountTrackerService : Service(), MethodChannel.MethodCallHandler {
    companion object {
        const val TAG = "StepCountTrackerService"
        const val ACTION_STOP_FOREGROUND = "stop_foreground"
        const val CALLBACK_HANDLE_EXTRA = "callback_handle_extra"
        const val BACKGROUND_METHOD_CHANNEL = "plugins.beam/step_counter_plugin_background"
        private var backgroundFlutterEngine: FlutterEngine? = null
    }

    private val onGoingNotificationId = 1;
    private var backgroundMethodChannel: MethodChannel? = null
    private var isFirstStart = true

    @Inject
    lateinit var stepCounterServiceStatusMonitor: StepCounterServiceStatusMonitor

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "onCreate")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "step_count_tracker_service"
            val channel = NotificationChannel(
                    channelId,
                    "Step count tracker service",
                    IMPORTANCE_LOW)
            val notificationManager =
                    getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

            val notification =
                    Notification.Builder(this, channelId)
                            .setContentTitle(getString(R.string.step_counter_notification_title))
                            .setContentText(getString(R.string.step_counter_notification_message))
                            .setSmallIcon(R.drawable.beam_logo)
                            .build()

            startForeground(onGoingNotificationId, notification)
        }
    }

    private fun initializeEngine(callbackHandle: Long?) {
        if (backgroundFlutterEngine == null) {
            FlutterMain.startInitialization(this)
            FlutterMain.ensureInitializationComplete(this, null)
            backgroundFlutterEngine = FlutterEngine(this)

            val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle!!)
            val dartCallback = DartExecutor.DartCallback(
                    assets,
                    FlutterMain.findAppBundlePath(),
                    callbackInfo
            )
            backgroundFlutterEngine!!.dartExecutor.executeDartCallback(dartCallback)
        }

        backgroundMethodChannel = MethodChannel(
                backgroundFlutterEngine!!.dartExecutor.binaryMessenger, BACKGROUND_METHOD_CHANNEL)
        backgroundMethodChannel?.setMethodCallHandler(this)
        backgroundMethodChannel?.invokeMethod("serviceStarted", null)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_FOREGROUND) {
            stepCounterServiceStatusMonitor.serviceStatus.value = false
            stopForeground(true)
            stopSelf()
        } else if (isFirstStart) {
            isFirstStart = false
            initializeEngine(intent?.extras?.getLong(CALLBACK_HANDLE_EXTRA))
        }
        return START_STICKY
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "step_tracker_initialized") {
            stepCounterServiceStatusMonitor.serviceStatus.value = true
        }
    }

    override fun onDestroy() {
        Log.d(TAG, "onDestroy")
        // onDestroy should be called by the framework automatically after calling stopSelf()
        backgroundMethodChannel?.invokeMethod("serviceStopped", null)
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? = null
}
