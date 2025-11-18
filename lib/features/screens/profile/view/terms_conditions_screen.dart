import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final loc = context.loc;

    final clauses = [
      _Clause(
        title: 'Account & Eligibility',
        details:
            'You must be 18+ years old to create an account. Keep your credentials private and notify us immediately if you suspect any unauthorized activity.',
        icon: Icons.badge_outlined,
        color: const Color(0xFF6366F1),
      ),
      _Clause(
        title: 'Orders & Payments',
        details:
            'All orders are subject to availability. Payments are processed securely and you will receive an instant confirmation email once successful.',
        icon: Icons.receipt_long_outlined,
        color: const Color(0xFFF97316),
      ),
      _Clause(
        title: 'Returns & Refunds',
        details:
            'Products can be returned if they are unused, with original packaging intact. Refunds are initiated to the original payment method within 2-5 business days.',
        icon: Icons.undo_outlined,
        color: const Color(0xFF14B8A6),
      ),
      _Clause(
        title: 'Fair Usage',
        details:
            'To keep the platform safe for everyone, abusive language, fraudulent activity, or misuse of offers can lead to account suspension.',
        icon: Icons.balance_outlined,
        color: const Color(0xFFEF4444),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.terms),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          children: [
            _TermsHero(responsive: responsive),
            SizedBox(height: responsive.spacing(24)),
            ...clauses.map(
              (clause) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(16)),
                child: _ClauseTile(clause: clause),
              ),
            ),
            SizedBox(height: responsive.spacing(16)),
            _AcceptanceNote(responsive: responsive),
          ],
        ),
      ),
    );
  }
}

class _TermsHero extends StatelessWidget {
  const _TermsHero({required this.responsive});

  final ResponsiveUtils responsive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(all: 22),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(responsive.borderRadius(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.loc.transparencyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            context.loc.transparencySubtitle,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ClauseTile extends StatelessWidget {
  const _ClauseTile({required this.clause});

  final _Clause clause;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(all: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
        border: Border.all(color: clause.color.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.spacing(10)),
            decoration: BoxDecoration(
              color: clause.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(clause.icon, color: clause.color),
          ),
          SizedBox(width: responsive.spacing(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clause.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: responsive.spacing(6)),
                Text(
                  clause.details,
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

class _AcceptanceNote extends StatelessWidget {
  const _AcceptanceNote({required this.responsive});

  final ResponsiveUtils responsive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Text(
              context.loc.acceptanceNote,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _Clause {
  const _Clause({
    required this.title,
    required this.details,
    required this.icon,
    required this.color,
  });

  final String title;
  final String details;
  final IconData icon;
  final Color color;
}
