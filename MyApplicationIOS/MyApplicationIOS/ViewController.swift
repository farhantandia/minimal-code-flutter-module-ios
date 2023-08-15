//
//  ViewController.swift
//  MyApplicationIOS
//
//  Created by TrendPower on 2023/8/9.
//

import UIKit
import tptaq_bms_util_plugin
import Flutter
import FlutterPluginRegistrant
import quick_blue
import path_provider_foundation

class ViewController: UIViewController, ObservableObject {
    let flutterEngine = FlutterEngine(name: "tptaq_bms_util_channel")
    var TPBMSPlugin: TptaqBmsUtilPlugin?

    
    @IBOutlet weak var bleDataLabel: UILabel!
    
    @IBAction func stopDiagnosisButton(_ sender: UIButton) {
        
            TPBMSPlugin!.stopDiagnosis()
                                 }
    @IBAction func fwUpdateButton(_ sender: UIButton) {
        
    }
    @IBAction func diagnosisButton(_ sender: UIButton) {
        TPBMSPlugin!.BMSDiagnosis(deviceName: "TPF004", username: "trendpower", password: "1234") { (result: Dictionary<String, Any>) in
                   // do stuff with the result
                   self.bleDataLabel.text = "\(result)"
               }
    }
    
    override func viewDidLoad() {
        
            flutterEngine.run()
//        let registrar = flutterEngine.registrar(forPlugin: "tptaqBmsUtilModule")
        let registrar = flutterEngine.registrar(forPlugin: "tptaqBmsUtilModule")
        TPBMSPlugin = TptaqBmsUtilPlugin(registrar: registrar!)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}

