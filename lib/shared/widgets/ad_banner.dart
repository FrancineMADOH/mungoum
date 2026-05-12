import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mungoum/core/config/ad_config.dart';

// Wrapper StatefulWidget requis : BannerAd a un cycle de vie (load/dispose).
// Si on ne dispose pas, le SDK AdMob continue de charger des pubs en arrière-plan.
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adUnitId = Platform.isIOS
        ? AdConfig.bannerAdUnitIdIOS
        : AdConfig.bannerAdUnitIdAndroid;

    final banner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        // Échec silencieux : aucune bannière affichée, aucun crash.
        // Normal hors ligne ou en zone sans inventaire publicitaire.
        onAdFailedToLoad: (_, __) {
          _bannerAd?.dispose();
          _bannerAd = null;
        },
      ),
    );

    banner.load();
    _bannerAd = banner;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
