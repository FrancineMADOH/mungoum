import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';

const _title = 'MUNGOUM';
const _totalMs = 3500;

// Title: each letter fades in over _letterFadeMs, one every _letterStaggerMs.
// Last letter ends at 6 × 110 + 240 = 900 ms.
const _letterStaggerMs = 110;
const _letterFadeMs = 240;

// Subtitle: fade + slide up + letter-spacing tightening, 900 → 1600 ms.
const _subtitleStartMs = 900;
const _subtitleEndMs = 1600;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final List<Animation<double>> _letterOpacities;
  late final Animation<double> _subtitle;

  @override
  void initState() {
    super.initState();

    // Durée totale : 3,5 secondes.
    // 0 → 900ms : « MUNGOUM » s'écrit lettre par lettre.
    // 900 → 1600ms : le sous-titre apparaît.
    // 1600 → 3500ms : tout reste affiché avant navigation.
    // Le logo pulse en parallèle : 1.0 → 1.08 (1000ms), retour (600ms), statique.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _totalMs),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 1000,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 600,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 1900,
      ),
    ]).animate(_controller);

    _letterOpacities = List.generate(_title.length, (i) {
      final startMs = i * _letterStaggerMs;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(
          startMs / _totalMs,
          (startMs + _letterFadeMs) / _totalMs,
          curve: Curves.easeOut,
        ),
      );
    });

    _subtitle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        _subtitleStartMs / _totalMs,
        _subtitleEndMs / _totalMs,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        context.go('/');
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Fond indigo identique au splash natif Android — transition invisible.
      backgroundColor: AppColors.indigoNight,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, logo) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(textTheme),
              const SizedBox(height: 24),
              ScaleTransition(scale: _scale, child: logo),
              const SizedBox(height: 24),
              _buildSubtitle(textTheme, l10n.appSubtitle),
            ],
          ),
          child: Image.asset(
            'assets/images/logo.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
            semanticLabel: 'Logo Mungoum',
          ),
        ),
      ),
    );
  }

  // Invisible letters keep their space, so the word never shifts while typing.
  Widget _buildTitle(TextTheme textTheme) {
    final style = textTheme.headlineLarge?.copyWith(
      color: AppColors.cream,
      fontWeight: FontWeight.w700,
      letterSpacing: 6,
    );

    return Semantics(
      label: 'Mungoum',
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          children: [
            for (var i = 0; i < _title.length; i++)
              TextSpan(
                text: _title[i],
                style: style?.copyWith(
                  color: AppColors.cream
                      .withValues(alpha: _letterOpacities[i].value),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle(TextTheme textTheme, String subtitle) {
    final t = _subtitle.value;

    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - t)),
        child: Text(
          subtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.amberGold,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5 + 4.5 * (1 - t),
          ),
        ),
      ),
    );
  }
}
