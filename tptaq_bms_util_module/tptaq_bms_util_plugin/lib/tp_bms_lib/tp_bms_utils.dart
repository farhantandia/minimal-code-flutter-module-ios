import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:quick_blue/quick_blue.dart';

enum TPUtilStatus { Ready, OnProcess }

const String SERVICE_UUID_EZDIAG = "0783b03e-8535-b5a0-7140-a304d2495cb7";
const String CHARACTERISTIC_UUID_TX_EZDIAG = "0783b03e-8535-b5a0-7140-a304d2495cba";
const String CHARACTERISTIC_UUID_RX_EZDIAG = "0783b03e-8535-b5a0-7140-a304d2495cb8";
const String CHARACTERISTIC_UUID_READ_EZDIAG = "0783b03e-8535-b5a0-7140-a304d2495cb9";

class TPBMSUtils {
  static TPUtilStatus utilStatus = TPUtilStatus.Ready;
  static int counter = 0;
  List<int> RXData = [];

  String DBC = "";
  String Ini = "";
  String PageInfo = "";
  final methodChannel = const MethodChannel('tptaq_bms_util_channel');
  List<int> checkSumCmdOTA = [82, 7, 2, 39, 0, 0, 0, 0, 0, 0, 0, 215];

  //Diagnosis local config file
  String pathBMS_ini = "packages/tptaq_bms_util_plugin/assets/UART-TPF004/BMS_UI.ini";
  String pathPageInfo = "packages/tptaq_bms_util_plugin/assets/UART-TPF004/PageInfo.xls";
  String pathDBC = "packages/tptaq_bms_util_plugin/assets/UART-TPF004/DBC.dbc";
  void initBLEHandler() {
    QuickBlue.setConnectionHandler(_handleConnectionChange);
    // QuickBlue.setServiceHandler(_handleServiceDiscovery );
    QuickBlue.setValueHandler(_handleValueChange);
  }

  void disposeBLEHandler() {
    QuickBlue.setValueHandler(null);
    // QuickBlue.setServiceHandler(null);
    QuickBlue.setConnectionHandler(null);
  }

  void _handleConnectionChange(String deviceId, BlueConnectionState state) {
    print('_handleConnectionChange $deviceId, $state');
  }

  void _handleServiceDiscovery(String deviceId, String serviceId, List<String> characteristicIds) {
    print('_handleServiceDiscovery $deviceId, $serviceId, $characteristicIds');
  }

  void _handleValueChange(String deviceId, String characteristicId, Uint8List value) {
    RXData = value;
    print('_handleValueChange $deviceId, $characteristicId, ${value}');
  }

  Future<String> onStartConnect(String deviceName, {String deviceId = ''}) async {
    String deviceID = '';
    List scanRes = [];
    QuickBlue.startScan();
    QuickBlue.scanResultStream.listen((result) async {
      if (result.name.isNotEmpty) {
        print('onScanResult ${result.name} ${result.deviceId}');
        scanRes.add(result.name);
      }
      if (result.name.contains(deviceName)) {
        deviceID = result.deviceId;
        QuickBlue.stopScan();
        await Future.delayed(Duration(milliseconds: 200));
        QuickBlue.connect(deviceID);
        print('CONNECTED to ${deviceID}');
        await Future.delayed(Duration(milliseconds: 200));
        initBLEHandler();
      }
    });

    await Future.delayed(Duration(seconds: 5));
    print(scanRes);
    QuickBlue.stopScan();
    if (deviceID.isNotEmpty) {
      QuickBlue.discoverServices(deviceID);
      await Future.delayed(Duration(milliseconds: 500));
      await QuickBlue.setNotifiable(
          deviceID, SERVICE_UUID_EZDIAG, CHARACTERISTIC_UUID_RX_EZDIAG, BleInputProperty.notification);
      await Future.delayed(Duration(milliseconds: 500));
    }
    return deviceID;
  }

  onDisconnect(String deviceID) {
    disposeBLEHandler();
    QuickBlue.disconnect(deviceID);
    print('Device $deviceID DISCONNECTED');
  }

  stopBMSDiagnosis() {
    utilStatus = TPUtilStatus.Ready;
    counter++;
    print("Diagnosis is stopped $counter");
    return "Diagnosis is stopped";
  }

  Future<String> writeFiletoRoot(String configFile, String filename) async {
    String? saveIniPath = "";
    try {
      // String dir = (await getApplicationDocumentsDirectory()).path; //app path
      saveIniPath = filename;
      var bytes = await rootBundle.load(configFile);

      print(bytes.buffer.lengthInBytes);

      final buffer = bytes.buffer;
      File(saveIniPath).writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      return saveIniPath;
    } catch (e, trace) {
      print(e);
      print(trace);

      saveIniPath = null;
    }
    return saveIniPath!;
  }

  Future<bool> copyConfigFile(String path) async {
    bool bResult = true;
    try {
      PageInfo = await writeFiletoRoot(pathPageInfo, path + '/PageInfo.xls');
      print(PageInfo);

      Ini = await writeFiletoRoot(pathBMS_ini, path + '/BMS_UI.ini');
      print(Ini);

      DBC = await writeFiletoRoot(pathDBC, path + '/DBC.dbc');
      print(DBC);
      bResult = true;
    } catch (e) {
      bResult = false;
    }

    return bResult;
  }

  Future<Map<String, String>> BMSDiagnosis(
    String deviceName, {
    String deviceId = '',
    String username = '',
    String password = '',
    String BMSconfigPath = '',
  }) async {
    Map<String, String> bmsDiagnosisData = {};
    if (utilStatus == TPUtilStatus.Ready) {
      utilStatus = TPUtilStatus.OnProcess;
      print(DateTime.now());
      methodChannel.invokeMethod('diagnosis', <String, Map>{
        'message': {"Message": "Start BMS Diagnosis..."},
      });
      String msg = "";
      print("$username $password $BMSconfigPath");
      String deviceID = "";
      print("test path provider");
      await copyConfigFile(BMSconfigPath);
      
      print("test quick blue");
      deviceID = await onStartConnect(deviceName);

      if (await QuickBlue.isBluetoothAvailable()) {
        methodChannel.invokeMethod('diagnosis', <String, Map>{
          'message': {"Message": "BLE OK..."},
        });
        deviceID = await onStartConnect(deviceName);

        onDisconnect(deviceID);
      } else {
        msg = "BLE is not available, please activate smartphone bluetooth.";
        bmsDiagnosisData = {"Message": msg};
      }

      utilStatus = TPUtilStatus.Ready;
    } else {
      bmsDiagnosisData = {
        "Message": "Another process is running, please wait for it to finish before execute others functions."
      };
    }

    return bmsDiagnosisData;
  }
}
