//
//  MyIosAppApp.swift
//  MyIosApp
//
//  Created by TrendPower on 2023/8/16.
//

import SwiftUI


import SwiftUI
import Flutter
import FlutterPluginRegistrant
import tptaq_bms_util_plugin

class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "io.fluter")
    var TPBMSPlugin: TptaqBmsUtilPlugin

    init(){
        flutterEngine.run()
        let registrar = flutterEngine.registrar(forPlugin: "TptaqBmsUtilPlugin")
        TPBMSPlugin = TptaqBmsUtilPlugin(registrar: registrar!)
    }

    @main
    struct MyIosAppApp: App {
        @StateObject var flutterDependencies = FlutterDependencies()
        var body: some Scene {
            WindowGroup {
                ContentView(plugin: flutterDependencies.TPBMSPlugin)
            }
        }
    }
}
