import 'dart:io';
import 'package:flutter/foundation.dart';

// AdMob banner Ad Unit IDs.
// Test IDs are Google's official public IDs — safe to commit, display fake ads.
// Replace production placeholders (XXXXX/YYYYY) just before the Play Store release.
// Never use real IDs in debug builds — accidental clicks cause account suspension.
abstract final class AdConfig {
  static String get bannerAdUnitIdAndroid => kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'   // Google official test ID
      : 'ca-app-pub-XXXXX/YYYYY';                   // TODO: replace before release

  static String get bannerAdUnitIdIOS => kDebugMode
      ? 'ca-app-pub-3940256099942544/2934735716'   // Google official test ID
      : 'ca-app-pub-AAAAA/BBBBB';                   // TODO: replace before release

  // Convenience getter — picks the right ID for the current platform.
  // Use this in BannerAd() instead of calling platform-specific getters directly.
  static String get bannerAdUnitId =>
      Platform.isIOS ? bannerAdUnitIdIOS : bannerAdUnitIdAndroid;
}
