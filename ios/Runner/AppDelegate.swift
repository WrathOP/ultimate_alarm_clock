import UIKit
import ActivityKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private let liveActivityManager: LiveActivityManager = LiveActivityManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let diChannel =  FlutterMethodChannel(name: "DI", binaryMessenger: controller.binaryMessenger)

    diChannel.setMethodCallHandler({ [weak self] (
           call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "startLiveActivity":
                    self?.liveActivityManager.startLiveActivity(
                        data: call.arguments as? Dictionary<String,Any>,
                        result: result)
                    break
                    
                case "updateLiveActivity":
                    self?.liveActivityManager.updateLiveActivity(
                        data: call.arguments as? Dictionary<String,Any>,
                        result: result)
                    break
                    
                case "stopLiveActivity":
                    self?.liveActivityManager.stopLiveActivity(result: result)
                    break
                    
                default:
                    result(FlutterMethodNotImplemented)
            }
       })


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class LiveActivityManager {
    

  private var timerActivity: Activity<timerDIWidgetAttributes>? = nil

  func startLiveActivity(data: [String: Any]?, result: FlutterResult) {
    let attributes = timerDIWidgetAttributes()
    

    if let info = data as? [String: Any] {
      let state = timerDIWidgetAttributes.ContentState(
        remainingTime: info["elapsedSeconds"] as? Int ?? 0
      )
      timerActivity = try? Activity<timerDIWidgetAttributes>.request(
        attributes: attributes, contentState: state, pushType: nil)
    } else {
      result(FlutterError(code: "418", message: "Live activity didn't invoked", details: nil))
    }
  }

func updateLiveActivity(data: [String: Any]?, result: FlutterResult) {
  if let info = data as? [String: Any] {
    let updatedState = timerDIWidgetAttributes.ContentState(
      remainingTime: info["elapsedSeconds"] as? Int ?? 0
    )

    Task {
      await timerActivity?.update(using: updatedState)
    }
  } else {
    result(FlutterError(code: "418", message: "Live activity didn't updated", details: nil))
  }
}

func stopLiveActivity(result: FlutterResult) {
  do {
    Task {
      await timerActivity?.end(using: nil, dismissalPolicy: .immediate)
    }
  } catch {
    result(FlutterError(code: "418", message: error.localizedDescription, details: nil))
  }
}
}

