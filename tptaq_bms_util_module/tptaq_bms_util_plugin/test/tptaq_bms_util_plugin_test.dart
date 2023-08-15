import 'package:flutter_test/flutter_test.dart';
import 'package:tptaq_bms_util_plugin/tptaq_bms_util_plugin.dart';
import 'package:tptaq_bms_util_plugin/tptaq_bms_util_plugin_platform_interface.dart';
import 'package:tptaq_bms_util_plugin/tptaq_bms_util_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTptaqBmsUtilPluginPlatform
    with MockPlatformInterfaceMixin
    implements TptaqBmsUtilPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TptaqBmsUtilPluginPlatform initialPlatform = TptaqBmsUtilPluginPlatform.instance;

  test('$MethodChannelTptaqBmsUtilPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTptaqBmsUtilPlugin>());
  });

  test('getPlatformVersion', () async {
    TptaqBmsUtilPlugin tptaqBmsUtilPlugin = TptaqBmsUtilPlugin();
    MockTptaqBmsUtilPluginPlatform fakePlatform = MockTptaqBmsUtilPluginPlatform();
    TptaqBmsUtilPluginPlatform.instance = fakePlatform;

    expect(await tptaqBmsUtilPlugin.getPlatformVersion(), '42');
  });
}
