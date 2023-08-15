import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tptaq_bms_util_plugin/tptaq_bms_util_plugin_method_channel.dart';

void main() {
  MethodChannelTptaqBmsUtilPlugin platform = MethodChannelTptaqBmsUtilPlugin();
  const MethodChannel channel = MethodChannel('tptaq_bms_util_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
