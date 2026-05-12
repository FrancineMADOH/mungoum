import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/router/app_router.dart';
import 'package:mungoum/core/theme/app_theme.dart';

// MobileAds must be initialized before runApp — it's async and must complete
// before any BannerAd is loaded, otherwise the SDK silently drops ad requests.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MungoumApp());
}

class MungoumApp extends StatelessWidget {
  const MungoumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mungoum',
      debugShowCheckedModeBanner: false,

      // ThemeMode.system follows the device light/dark setting automatically.
      // Both themes are built from the ndop palette — see core/theme/app_theme.dart.
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,

      routerConfig: appRouter,

      // Fallback locale is the first entry in supportedLocales (EN).
      // Device locales not in [fr, en] will silently fall back to EN.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
