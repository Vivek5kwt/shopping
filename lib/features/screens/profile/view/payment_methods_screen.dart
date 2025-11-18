import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  final List<_PaymentCard> _cards = const [
    _PaymentCard(
      brand: 'Visa',
      last4: '1248',
      expiry: '07/27',
      color: const Color(0xFF2563EB),
    ),
    _PaymentCard(
      brand: 'Mastercard',
      last4: '9812',
      expiry: '02/26',
      color: const Color(0xFF0EA5E9),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.paymentMethods),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          children: [
            _PaymentHeader(
              title: loc.paymentMethods,
              subtitle: loc.paymentMethodsSubtitle,
            ),
            SizedBox(height: responsive.spacing(20)),
            ..._cards.map(
              (card) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(16)),
                child: _PaymentCardWidget(card: card),
              ),
            ),
            SizedBox(height: responsive.spacing(12)),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_card),
              label: Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
                child: Text(loc.addPaymentMethodCta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentCardWidget extends StatelessWidget {
  const _PaymentCardWidget({required this.card});

  final _PaymentCard card;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final loc = context.loc;

    return Container(
      width: double.infinity,
      padding: responsive.padding(all: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(24)),
        gradient: LinearGradient(
          colors: [
            card.color,
            card.color.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: card.color.withOpacity(0.35),
            blurRadius: responsive.spacing(18),
            offset: Offset(0, responsive.spacing(8)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.brand,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing(10),
                  vertical: responsive.spacing(4),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius:
                      BorderRadius.circular(responsive.borderRadius(16)),
                ),
                child: Text(
                  loc.primaryBadge,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(24)),
          Text(
            '•••• •••• •••• ${card.last4}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: responsive.spacing(12)),
          Row(
            children: [
              _InfoChip(label: loc.expiryLabel, value: card.expiry),
              SizedBox(width: responsive.spacing(12)),
              _InfoChip(label: loc.cardHolderLabel, value: 'You'),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(loc.editProfile),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline),
                  label: Text(loc.removeAction),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard {
  const _PaymentCard({
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.color,
  });

  final String brand;
  final String last4;
  final String expiry;
  final Color color;
}

class _PaymentHeader extends StatelessWidget {
  const _PaymentHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.spacing(6)),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
