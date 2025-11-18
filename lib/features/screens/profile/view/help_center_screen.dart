import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);

    final quickActions = [
      _HelpAction(
        title: loc.contactSupport,
        subtitle: loc.chatWithTeam,
        icon: Icons.chat_bubble_outline,
        color: const Color(0xFF3B82F6),
      ),
      _HelpAction(
        title: loc.trackOrder,
        subtitle: loc.trackOrderSubtitle,
        icon: Icons.local_shipping_outlined,
        color: const Color(0xFF10B981),
      ),
      _HelpAction(
        title: loc.reportIssue,
        subtitle: loc.reportIssueSubtitle,
        icon: Icons.report_gmailerrorred_outlined,
        color: const Color(0xFFF97316),
      ),
    ];

    final faqs = [
      _FaqItem(
        question: 'How do I track my orders?',
        answer:
            'Open the Orders section from your profile and tap on any order to view live tracking updates, courier details, and delivery timelines.',
      ),
      _FaqItem(
        question: 'What is the return policy?',
        answer:
            'Most products can be returned within 10 days of delivery. Open the order details, tap on "Return / Replace" and follow the guided steps.',
      ),
      _FaqItem(
        question: 'How can I contact customer care?',
        answer:
            'You can chat with our care team 24/7 or send an email to care@shop.com. We usually respond within a few minutes.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.helpCenter),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroCard(responsive: responsive, loc: loc),
              SizedBox(height: responsive.spacing(24)),
              Text(
                loc.quickActions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: responsive.spacing(12)),
              ...quickActions.map(
                (action) => Padding(
                  padding: EdgeInsets.only(bottom: responsive.spacing(12)),
                  child: _QuickActionTile(action: action),
                ),
              ),
              SizedBox(height: responsive.spacing(16)),
              Text(
                loc.faqs,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: responsive.spacing(12)),
              ...faqs.map(
                (faq) => Padding(
                  padding: EdgeInsets.only(bottom: responsive.spacing(12)),
                  child: _FaqTile(faq: faq),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.responsive, required this.loc});

  final ResponsiveUtils responsive;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: responsive.padding(all: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(28)),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.35),
            blurRadius: responsive.spacing(16),
            offset: Offset(0, responsive.spacing(10)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.support_agent,
            color: Colors.white,
            size: responsive.iconSize(36),
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            loc.needHelpTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            loc.helpHeroDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _HelpAction action;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.spacing(12),
            offset: Offset(0, responsive.spacing(4)),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.spacing(10)),
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(action.icon, color: action.color),
          ),
          SizedBox(width: responsive.spacing(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  action.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).hintColor),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.faq});

  final _FaqItem faq;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: _isExpanded ? theme.colorScheme.primary : Colors.grey.shade300,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.faq.question,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.only(top: responsive.spacing(10)),
                child: Text(
                  widget.faq.answer,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpAction {
  const _HelpAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
