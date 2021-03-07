import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    static var backgroundIsolateRun = false
    
    var serviceStatusEventSink: FlutterEventSink?
    var headlessRunner: FlutterEngine?
    var backgroundChannel: FlutterMethodChannel?
    var isServiceRunning = false
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let serviceStatusChannel = FlutterEventChannel(name: "plugins.beam/step_counter_service_status_plugin", binaryMessenger: controller.binaryMessenger)
        
        serviceStatusChannel.setStreamHandler(self)
        
        let channel = FlutterMethodChannel(name:"plugins.beam/step_counter_plugin",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            let arguments = call.arguments as? Array<Any?>
            
            switch call.method {
            case "StepCounterService.initializeService":
                self?.startService(callbackHandle: arguments?[0] as! Int64)
                result("initializing")
            case "StepCounterService.isInitialized":
                result(self?.isServiceRunning)
            case "StepCounterService.stopService":
                if let sink = self?.serviceStatusEventSink {
                    sink(false)
                }
                self?.isServiceRunning = false
                result("stopping")
            default:
                result(FlutterMethodNotImplemented);
            }
        })
        
        headlessRunner = FlutterEngine(name: "StepCounterIsolate", project: nil, allowHeadlessExecution: true)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func startService(callbackHandle: Int64) {
        let info = FlutterCallbackCache.lookupCallbackInformation(callbackHandle)
        let entrypoint = info?.callbackName
        let uri = info?.callbackLibraryPath
        
        headlessRunner?.run(withEntrypoint: entrypoint, libraryURI: uri)
        
        if (!AppDelegate.backgroundIsolateRun) {
            GeneratedPluginRegistrant.register(with: headlessRunner!)
        }
        AppDelegate.backgroundIsolateRun = true
        
        backgroundChannel = FlutterMethodChannel(name:"plugins.beam/step_counter_plugin_background", binaryMessenger: headlessRunner as! FlutterBinaryMessenger)
        
        backgroundChannel?.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if call.method == "step_tracker_initialized" {
                if let sink = self?.serviceStatusEventSink {
                    sink(true)
                }
                self?.isServiceRunning = true
            }
        })
        
        backgroundChannel?.invokeMethod("serviceStarted", arguments: nil)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        serviceStatusEventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
