import UIKit
import Flutter
import AVFoundation
import PushKit
import CallKit
import TwilioVoice

let accessToken = "PASTE_YOUR_ACCESS_TOKEN_HERE"
let twimlParamTo = "to"

let kCachedDeviceToken = "CachedDeviceToken"


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let METHOD_CHANNEL_NAME = "voice_quickstart"
      let voiceChannel = FlutterMethodChannel(name:METHOD_CHANNEL_NAME,binaryMessenger: controller.binaryMessenger)
      
      voiceChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "makeCall":
              guard let args = call.arguments as? [String:String] else {return}
              let accessToken = args["accessToken"]!
              
              self.callVoice(accessToken: accessToken)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      
//      let vcontroller = window?.rootViewController as! FlutterViewController
      
      GeneratedPluginRegistrant.register(with: self)
      
      // create and then add a new UINavigationController
//      self.navigationController = UINavigationController(rootViewController: vcontroller)
//      self.window.rootViewController = self.navigationController
//      self.navigationController.setNavigationBarHidden(true, animated: false)
//      self.window.makeKeyAndVisible()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func callVoice(accessToken: String)->Void{
        
//        self.navigationController.setNavigationBarHidden(false, animated: true)
//        self.navigationController.pushViewController(vc, animated: true)
        class ViewController: UIViewController {
           
        }
    }
}


