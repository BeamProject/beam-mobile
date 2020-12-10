package com.example.beam

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.IMPORTANCE_DEFAULT
import android.app.NotificationManager.IMPORTANCE_MIN
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
        const val BACKGROUND_METHOD_CHANNEL = "plugins.beam/step_counter_plugin_background"
        private var backgroundFlutterEngine: FlutterEngine? = null
    }

    private val onGoingNotificationId = 1;
    private lateinit var backgroundMethodChannel: MethodChannel

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
                    IMPORTANCE_MIN)
            val notificationManager =
                    getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)

            val notificationBuilder =
                    Notification.Builder(this, channelId)

            notificationBuilder.setContentTitle(getText(R.string.step_counter_notification_title))
                    .setContentText(getText(R.string.step_counter_notification_message))

            startForeground(onGoingNotificationId, notificationBuilder.build())
        }

        if (backgroundFlutterEngine == null) {
            FlutterMain.startInitialization(this)
            FlutterMain.ensureInitializationComplete(this, null)

            val callbackHandle =
                    getSharedPreferences(StepCounterPlugin.SHARED_PREFS_KEY, Context.MODE_PRIVATE)
                            .getLong(StepCounterPlugin.CALLBACK_DISPATCHER_HANDLE_KEY, 0)

            if (callbackHandle == 0L) {
                Log.e(TAG, "Fatal: no callback registered")
                return
            }

            backgroundFlutterEngine = FlutterEngine(this)

            val callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
            val dartCallback = DartExecutor.DartCallback(
                    assets,
                    FlutterMain.findAppBundlePath(),
                    callbackInfo
            )

            backgroundFlutterEngine!!.dartExecutor.executeDartCallback(dartCallback)
        }

        backgroundMethodChannel = MethodChannel(
                backgroundFlutterEngine!!.dartExecutor.binaryMessenger, BACKGROUND_METHOD_CHANNEL)
        backgroundMethodChannel.setMethodCallHandler(this)
        backgroundMethodChannel.invokeMethod("serviceStarted", null)

    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP_FOREGROUND) {
            stepCounterServiceStatusMonitor.serviceStatus.value = false
            stopForeground(true)
            stopSelf()
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
        backgroundMethodChannel.invokeMethod("serviceStopped", null)
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? = null
}
