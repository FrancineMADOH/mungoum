import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mungoum/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // Durée totale : 3 secondes.
    // Phase 1 (0→17%) : 500ms — logo statique.
    // Phase 2 (17→50%) : 1000ms — expansion 1.0 → 1.08.
    // Phase 3 (50→67%) : 500ms — retour 1.08 → 1.0.
    // Phase 4 (67→100%) : 1000ms — logo statique avant navigation.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 17,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 33,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 17,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 33,
      ),
    ]).animate(_controller);

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
    return Scaffold(
      // Fond indigo identique au splash natif Android — transition invisible.
      backgroundColor: AppColors.indigoNight,
      body: Center(
        child: ScaleTransition(
          scale: _scale,
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
}
