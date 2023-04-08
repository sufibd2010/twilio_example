import UIKit
import Flutter
import TwilioVoice
import PushKit

protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void
    func credentialsInvalidated() -> Void
    func incomingPushReceived(payload: PKPushPayload) -> Void
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void
}


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {

    var pushKitEventDelegate: PushKitEventDelegate?
    var voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      NSLog("Twilio Voice Version: %@", TwilioVoiceSDK.sdkVersion())
      
      let viewController = UIApplication.shared.windows.first?.rootViewController as? ViewController
    
      
    initializePushKit()

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let METHOD_CHANNEL_NAME = "voice_quickstart"
      let voiceChannel = FlutterMethodChannel(name:METHOD_CHANNEL_NAME,binaryMessenger: controller.binaryMessenger)
      
      voiceChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "makeCall":
              guard let args = call.arguments as? [String:String] else {return}
              let accessToken = args["accessToken"]!
              viewController?.accessToken = accessToken
//              destinationVC?.present(viewController!, animated: true)
              self.pushKitEventDelegate = viewController
              self.callVoice(accessToken: accessToken)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func callVoice(accessToken: String)->Void{
        
        NSLog("Clicked Make Call Button, AccessToken : %@",accessToken)
    }
    
    func initializePushKit() {
           voipRegistry.delegate = self
           voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
       }

    override func applicationWillResignActive(_ application: UIApplication) {
           // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
           // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
       }

    override func applicationDidEnterBackground(_ application: UIApplication) {
           // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
           // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       }

    override func applicationWillEnterForeground(_ application: UIApplication) {
           // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
       }

    override func applicationDidBecomeActive(_ application: UIApplication) {
           // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       }

    override func applicationWillTerminate(_ application: UIApplication) {
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       }
       
       // MARK: PKPushRegistryDelegate
       func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
           NSLog("pushRegistry:didUpdatePushCredentials:forType:")
           
           if let delegate = self.pushKitEventDelegate {
               delegate.credentialsUpdated(credentials: credentials)
           }
       }
       
       func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
           NSLog("pushRegistry:didInvalidatePushTokenForType:")
           
           if let delegate = self.pushKitEventDelegate {
               delegate.credentialsInvalidated()
           }
       }

       /**
        * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
        * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
        */
       func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
           NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
           
           if let delegate = self.pushKitEventDelegate {
               delegate.incomingPushReceived(payload: payload)
           }
       }

       /**
        * This delegate method is available on iOS 11 and above. Call the completion handler once the
        * notification payload is passed to the `TwilioVoiceSDK.handleNotification()` method.
        */
       func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
           NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")

           if let delegate = self.pushKitEventDelegate {
               delegate.incomingPushReceived(payload: payload, completion: completion)
           }
           
           if let version = Float(UIDevice.current.systemVersion), version >= 13.0 {
               /**
                * The Voice SDK processes the call notification and returns the call invite synchronously. Report the incoming call to
                * CallKit and fulfill the completion before exiting this callback method.
                */
               completion()
           }
       }
   

}


