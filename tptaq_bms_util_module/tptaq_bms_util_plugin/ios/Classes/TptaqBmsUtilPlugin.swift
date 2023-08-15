import Flutter
import UIKit

public class TptaqBmsUtilPlugin: NSObject, FlutterPlugin {
    
//    var flutterViewController: FlutterViewController?
    var channel: FlutterMethodChannel



    public init(registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "tptaq_bms_util_channel", binaryMessenger: registrar.messenger())
        super.init()
        registrar.addMethodCallDelegate(self, channel: channel)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = TptaqBmsUtilPlugin(registrar: registrar)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result("iOS " + UIDevice.current.systemVersion)
    }
    public func BMSDiagnosis(deviceName: String, deviceId:String = "",username: String = "", password: String = "", bmsConfigPath :String = "", completion: @escaping (Dictionary<String, Any>)->()){
        if bmsConfigPath.count > 0 {
            
            channel.invokeMethod("diagnosis", arguments:  ["devicename":deviceName, "deviceid":deviceId, "bmsconfigpath":bmsConfigPath])
            
        } else if (username.count > 0 && password.count > 0){
            
            channel.invokeMethod("diagnosis", arguments:  ["devicename":deviceName, "deviceid":deviceId, "username":username, "password":password])
        }
        else{
            completion(["Message":"Please fill username and password or bms configuration path in order to get bms diagnosis data."])
        }
        channel.setMethodCallHandler { (call, result) in
            let arguments = call.arguments as? Dictionary<String, Any>
            print(arguments)
            let res = arguments!["message"] as? Dictionary<String, Any>?
            completion(res!!)
        }
    }
    
    public func stopDiagnosis(){
        channel.invokeMethod("stopdiagnosis", arguments: nil)
    }
    
}
