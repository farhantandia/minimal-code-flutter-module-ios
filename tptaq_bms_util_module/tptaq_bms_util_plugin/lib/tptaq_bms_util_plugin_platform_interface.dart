import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tptaq_bms_util_plugin_method_channel.dart';

abstract class TptaqBmsUtilPluginPlatform extends PlatformInterface {
  /// Constructs a TptaqBmsUtilPluginPlatform.
  TptaqBmsUtilPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TptaqBmsUtilPluginPlatform _instance = MethodChannelTptaqBmsUtilPlugin();

  /// The default instance of [TptaqBmsUtilPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTptaqBmsUtilPlugin].
  static TptaqBmsUtilPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TptaqBmsUtilPluginPlatform] when
  /// they register themselves.
  static set instance(TptaqBmsUtilPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
