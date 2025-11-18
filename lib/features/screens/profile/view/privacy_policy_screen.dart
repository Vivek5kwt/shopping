import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final loc = context.loc;

    final sections = [
      _PolicySection(
        title: 'Data We Collect',
        description:
            'We only collect the information you share while creating an account, placing an order, or contacting support. This includes your name, email, delivery address, preferences, and payment details (processed securely).',
        icon: Icons.storage_outlined,
        color: const Color(0xFF3B82F6),
      ),
      _PolicySection(
        title: 'How We Use Your Data',
        description:
            'Your data powers personalized recommendations, safe payments, shipping updates, and proactive support. We never sell your data and only share it with trusted logistics & payment partners.',
        icon: Icons.verified_user_outlined,
        color: const Color(0xFF10B981),
      ),
      _PolicySection(
        title: 'Your Privacy Controls',
        description:
            'Update your information anytime from the profile section, manage marketing preferences, or request data deletion by writing to privacy@shop.com.',
        icon: Icons.lock_open_outlined,
        color: const Color(0xFFF59E0B),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.privacyPolicy),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          children: [
            _GradientBanner(responsive: responsive, theme: theme, loc: loc),
            SizedBox(height: responsive.spacing(24)),
            ...sections.map(
              (section) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(16)),
                child: _PolicyCard(section: section),
              ),
            ),
            SizedBox(height: responsive.spacing(12)),
            _PrivacyFooter(responsive: responsive, loc: loc),
          ],
        ),
      ),
    );
  }
}

class _GradientBanner extends StatelessWidget {
  const _GradientBanner({
    required this.responsive,
    required this.theme,
    required this.loc,
  });

  final ResponsiveUtils responsive;
  final ThemeData theme;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: responsive.padding(all: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.borderRadius(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.privacy_tip, color: Colors.white, size: responsive.iconSize(32)),
          SizedBox(height: responsive.spacing(12)),
          Text(
            loc.respectPrivacyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            loc.respectPrivacySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.section});

  final _PolicySection section;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(all: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: responsive.spacing(14),
            offset: Offset(0, responsive.spacing(6)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.spacing(10)),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(section.icon, color: section.color),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            section.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            section.description,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PrivacyFooter extends StatelessWidget {
  const _PrivacyFooter({required this.responsive, required this.loc});

  final ResponsiveUtils responsive;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(all: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.email_outlined, color: theme.colorScheme.primary),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.needSomethingElse,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  loc.privacyEmailDescription,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  const _PolicySection({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
