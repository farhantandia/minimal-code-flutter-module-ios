
import 'package:tptaq_bms_util_plugin/tptaq_bms_util_plugin_method_channel.dart';

import 'tptaq_bms_util_plugin_platform_interface.dart';

class TptaqBmsUtilPlugin {
  Future<String?> getPlatformVersion() {
    return TptaqBmsUtilPluginPlatform.instance.getPlatformVersion();
  }
  final MethodChannelTptaqBmsUtilPlugin methodChannelTptaqBmsUtilPlugin;

  TptaqBmsUtilPlugin()
      : methodChannelTptaqBmsUtilPlugin = MethodChannelTptaqBmsUtilPlugin();
}
