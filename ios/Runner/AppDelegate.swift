import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    var serviceStatusEventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let serviceStatusChannel = FlutterEventChannel(name: "plugins.beam/step_counter_service_status_plugin", binaryMessenger: controller.binaryMessenger)
        
        serviceStatusChannel.setStreamHandler(self)
        
        let channel = FlutterMethodChannel(name:"plugins.beam/step_counter_plugin",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            switch call.method {
            case "StepCounterService.initializeService":
                result("initializing")
            case "StepCounterService.isInitialized":
                result(false)
            case "StepCounterService.stopService":
                if let sink = self?.serviceStatusEventSink {
                    sink(false)
                }
                result("stopping")
            default:
                result(FlutterMethodNotImplemented);
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        serviceStatusEventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
