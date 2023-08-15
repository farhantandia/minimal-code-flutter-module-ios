import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tptaq_bms_util_plugin/tp_bms_lib/tp_bms_utils.dart';

import 'tptaq_bms_util_plugin_platform_interface.dart';

/// An implementation of [TptaqBmsUtilPluginPlatform] that uses method channels.
class MethodChannelTptaqBmsUtilPlugin extends TptaqBmsUtilPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tptaq_bms_util_channel');
  MethodChannelTptaqBmsUtilPlugin() {
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future methodHandler(MethodCall call) async {
    switch (call.method) {
      case "diagnosis":
        String username = call.arguments['username'] ?? '';
        String password = call.arguments['password'] ?? '';
        String configPath = call.arguments['bmsconfigpath'] ?? '';
        String deviceName = call.arguments['devicename'] ?? '';
        String deviceId = call.arguments['deviceId'] ?? '';
        Map Data = await TPBMSUtils().BMSDiagnosis(deviceName,
            deviceId: deviceId, username: username, password: password, BMSconfigPath: configPath);
        methodChannel.invokeMethod('diagnosis', <String, Map>{
          'message': Data,
        });
        break;
        
        case "stopdiagnosis":
        String message =  TPBMSUtils().stopBMSDiagnosis();       
        // methodChannel.invokeMethod('stopdiagnosis', <String, String>{
        //   'message': message,
        // });
        break;
      // case "hello_world":
      //   String message = TPBMSUtils().helloWorld();
      //   methodChannel.invokeMethod('hello_world', <String, String>{
      //     'message': message,
      //   });
      //   break;
      // case "sum_number":
      //   List argument = call.arguments['number'];
      //   int res = TPBMSUtils().sum(argument.first, argument.last);
      //   methodChannel.invokeMethod('sum_number', <String, int>{
      //     'message': res,
      //   });
      //   break;
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
