import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mungoum/core/l10n/app_localizations.dart';
import 'package:mungoum/core/theme/app_theme.dart';
import 'package:mungoum/shared/widgets/app_scaffold.dart';

// URL donation — chaîne vide = bouton masqué. Remplacer par l'URL réelle avant la release.
const _donationUrl = 'https://www.paypal.com/donate';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 3,
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          final version = snapshot.data?.version ?? '';
          return _AboutBody(version: version);
        },
      ),
    );
  }
}

class _AboutBody extends StatelessWidget {
  final String version;
  const _AboutBody({required this.version});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AppHeader(version: version, l10n: l10n),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              _AboutSection(l10n: l10n),
              const SizedBox(height: 32),
              if (_donationUrl.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 24),
                _DonationButton(l10n: l10n),
                const SizedBox(height: 32),
              ],
              const Divider(),
              const SizedBox(height: 24),
              _CreditsSection(l10n: l10n),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  final String version;
  final AppLocalizations l10n;

  const _AppHeader({required this.version, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
          fit: BoxFit.contain,
          semanticLabel: 'Logo Mungoum',
        ),
        const SizedBox(height: 16),
        Text(
          'Mungoum',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.appSubtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.amberGold,
              ),
        ),
        if (version.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${l10n.version} $version',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
          ),
        ],
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _AboutSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bamougoum',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.amberGold,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.appDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
        ),
      ],
    );
  }
}

class _DonationButton extends StatelessWidget {
  final AppLocalizations l10n;
  const _DonationButton({required this.l10n});

  Future<void> _launch() async {
    final uri = Uri.parse(_donationUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _launch,
      icon: const Icon(Icons.favorite_outline),
      label: Text(l10n.supportProject),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.amberGold,
        side: const BorderSide(color: AppColors.amberGold),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _CreditsSection extends StatelessWidget {
  final AppLocalizations l10n;
  const _CreditsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          height: 1.6,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.credits,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.amberGold,
              ),
        ),
        const SizedBox(height: 12),
        Text(l10n.developedBy, style: secondary),
        const SizedBox(height: 4),
        Text(l10n.calendarSource, style: secondary),
      ],
    );
  }
}
