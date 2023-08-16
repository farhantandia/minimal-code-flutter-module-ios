//
//  ContentView.swift
//  MyIosApp
//
//  Created by TrendPower on 2023/8/16.
//

import SwiftUI
import tptaq_bms_util_plugin

struct ContentView: View {
    var TPBMSPlugin: TptaqBmsUtilPlugin
    init(plugin: TptaqBmsUtilPlugin) {
        TPBMSPlugin = plugin
    }
    var body: some View {
        var resultLabel: String = "No Data"
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(resultLabel)
            VStack {
                Button("Diagnosis") {
                    TPBMSPlugin.BMSDiagnosis(deviceName: "TPF004", username: "trendpower", password: "1234") { (result: Dictionary<String, Any>) in
                        // do stuff with the result
                        resultLabel = "\(result)"
                        print(result)
                    }
                }   .padding(.all)
                Button("Stop") {
                    
                    resultLabel = "Stop Diagnosis"
                    TPBMSPlugin.stopDiagnosis()}   .padding(.all)
            }
        }
        
        
    }
}



