import UIKit
import Flutter
import CoreMotion
import BackgroundTasks

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    static let callbackHandleKey = "callbackHandleKey"
    static var backgroundIsolateRun = false
    
    private let pedometer = CMPedometer()
    private let dateFormatter = ISO8601DateFormatter()
    var serviceStatusEventSink: FlutterEventSink?
    var headlessRunner: FlutterEngine?
    var backgroundChannel: FlutterMethodChannel?
    var isServiceRunning = false

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
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
                let callbackHandle = arguments?[0] as! Int64
                UserDefaults.standard.set(callbackHandle, forKey: AppDelegate.callbackHandleKey)
                self?.initializeService(callbackHandle: callbackHandle) {() -> () in
                    if let sink = self?.serviceStatusEventSink {
                        sink(true)
                    }
                    self?.isServiceRunning = true
                }
                self?.startService()
                result("initializing")
            case "StepCounterService.isInitialized":
                result(self?.isServiceRunning)
            case "StepCounterService.stopService":
                if let sink = self?.serviceStatusEventSink {
                    sink(false)
                }
                if let bgChannel = self?.backgroundChannel {
                    bgChannel.invokeMethod("serviceStopped", arguments: nil)
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
    
    override func application(
      _ application: UIApplication,
      performFetchWithCompletionHandler
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("on bg fetch")
        if (headlessRunner == nil) {
            print("creating headless runner")
            headlessRunner = FlutterEngine(name: "StepCounterIsolate", project: nil, allowHeadlessExecution: true)
        }
        if let callbackHandle = UserDefaults.standard.object(forKey: AppDelegate.callbackHandleKey) as? Int64 {
            initializeService(callbackHandle: callbackHandle) {() -> () in
                print("Completing task")
                completionHandler(.newData)
            }
            backgroundChannel?.invokeMethod("isServiceEnabled", arguments: nil, result: {[weak self] (res) -> () in
                if let result = res as? Bool {
                   if (result == true) {
                    print("service enabled, starting...")
                    self?.startService()
                   } else {
                    print("service not enabled, returning")
                    completionHandler(.noData)
                   }
                } else {
                    completionHandler(.failed)
                }
            })
            completionHandler(.newData)
        } else {
            print("callback not registered, returning")
            completionHandler(.noData)
        }
    }
    
    func initializeService(callbackHandle: Int64, onServiceInitialized: @escaping () -> ()) {
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
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "step_tracker_initialized" {
                onServiceInitialized()
            } else if call.method == "query_step_count_data" {
                let args = call.arguments as! NSDictionary
                let trimmedIsoFrom = (args["from"] as! String).replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                let trimmedIsoTo = (args["to"] as! String).replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
                let from = self?.dateFormatter.date(from: trimmedIsoFrom)
                let to = self?.dateFormatter.date(from: trimmedIsoTo)
                self?.getStepCountData(from: from!, to: to!, result: result)
            }
        })
    }
    
    func startService() {
        backgroundChannel?.invokeMethod("serviceStarted", arguments: nil)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        serviceStatusEventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func getStepCountData(from: Date, to:Date, result:@escaping FlutterResult) {
        pedometer.queryPedometerData(from: from, to: to) { [weak self] (data, error) in
            DispatchQueue.main.async {
                result([
                        "from": self?.dateFormatter.string(from: from) ?? "",
                        "to": self?.dateFormatter.string(from: to) ?? "",
                        "steps": data?.numberOfSteps ?? -1])
            }
        }
    }
}
