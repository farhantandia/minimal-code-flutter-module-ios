//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<quick_blue/QuickBluePlugin.h>)
#import <quick_blue/QuickBluePlugin.h>
#else
@import quick_blue;
#endif

#if __has_include(<tptaq_bms_util_plugin/TptaqBmsUtilPlugin.h>)
#import <tptaq_bms_util_plugin/TptaqBmsUtilPlugin.h>
#else
@import tptaq_bms_util_plugin;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [QuickBluePlugin registerWithRegistrar:[registry registrarForPlugin:@"QuickBluePlugin"]];
  [TptaqBmsUtilPlugin registerWithRegistrar:[registry registrarForPlugin:@"TptaqBmsUtilPlugin"]];
}

@end
