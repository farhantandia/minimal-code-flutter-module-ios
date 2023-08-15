package com.example.tptaq_bms_util_plugin

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TptaqBmsUtilPlugin */
class TptaqBmsUtilPlugin(): FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel


    companion object {
        fun fromEngine(flutterEngine: FlutterEngine): TptaqBmsUtilPlugin {
            return flutterEngine.plugins.get(TptaqBmsUtilPlugin::class.java) as TptaqBmsUtilPlugin
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tptaq_bms_util_channel")
        channel.setMethodCallHandler(this)

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun BMSDiagnosis(deviceName:String, deviceId:String = "",username: String = "", password: String = "", bmsConfigPath :String="", callback: (Map<*,*>) -> Unit) {
        
        if (bmsConfigPath.isNotEmpty()){
            channel.invokeMethod("diagnosis", mapOf("devicename" to deviceName,"deviceid" to deviceId,"bmsconfigpath" to bmsConfigPath))
        }else if(username.isNotEmpty() && password.isNotEmpty()){
            channel.invokeMethod("diagnosis", mapOf("devicename" to deviceName,"deviceid" to deviceId,"username" to username, "password" to password
            ))
        }
        else{
            callback(mapOf("Message" to "Please fill username and password or bms configuration path in order to get bms diagnosis data."))
        }

        channel.setMethodCallHandler { call, _ ->
            val arguments = call.arguments<Map<String, Any>>()
            var res = arguments?.get("message") as Map<*, *>

            callback(res)

        }
    }

    fun BMSFWUpdate(deviceName:String, deviceId:String = "",username: String = "", password: String = "", bmsConfigPath :String="", callback: (Map<*,*>) -> Unit) {

        if (bmsConfigPath.isNotEmpty()){
            channel.invokeMethod("fwupdate", mapOf("devicename" to deviceName,"deviceid" to deviceId,"fwconfigpath" to bmsConfigPath))
        }else if(username.isNotEmpty() && password.isNotEmpty()){
            channel.invokeMethod("fwupdate", mapOf("devicename" to deviceName,"deviceid" to deviceId,"username" to username, "password" to password
            ))
        }
        else{
            callback(mapOf("Message" to "Please fill username and password or firmware configuration path in order to perform firmware update"))
        }

        channel.setMethodCallHandler { call, _ ->
            val arguments = call.arguments<Map<String, Any>>()
            var res = arguments?.get("message") as Map<*, *>

            callback(res)

        }
    }
    fun stopDiagnosis(callback: (String) -> Unit) {
        channel.invokeMethod("stopdiagnosis", null)
        // channel.setMethodCallHandler { call, _ ->
        //     val arguments = call.arguments<Map<String, Any>>()
        //     var res = arguments?.get("message") as String
        //     if (res != "") {
        //         callback(res)

        //     } else {
        //         callback(res)
        //     }
        // }
    }

        fun sayHello(callback: (String) -> Unit) {
            channel.invokeMethod("hello_world", null)
            channel.setMethodCallHandler { call, _ ->
                val arguments = call.arguments<Map<String, Any>>()
                var res = arguments?.get("message") as String
                if (res != "") {
                    callback(res)

                } else {
                    callback(res)
                }
            }
        }

        fun sumNumber(a: Int, b: Int, callback: (Int) -> Unit) {

            channel.invokeMethod("sum_number", mapOf("number" to listOf(a, b)))
            channel.setMethodCallHandler { call, _ ->
                val arguments = call.arguments<Map<String, Any>>()
                var res = arguments?.get("message") as Int
                callback(res)

            }

        }
    }


