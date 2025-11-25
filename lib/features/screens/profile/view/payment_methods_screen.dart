import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<_PaymentCard> _cards = [
    const _PaymentCard(
      brand: 'Visa',
      last4: '1248',
      expiry: '07/27',
      color: Color(0xFF2563EB),
      isPrimary: true,
    ),
    const _PaymentCard(
      brand: 'Mastercard',
      last4: '9812',
      expiry: '02/26',
      color: Color(0xFF0EA5E9),
      isPrimary: false,
    ),
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _markAsPrimary(_PaymentCard card) {
    setState(() {
      for (var i = 0; i < _cards.length; i++) {
        _cards[i] = _cards[i].copyWith(isPrimary: _cards[i] == card);
      }
    });

    _showSnackBar('${card.brand} •••• ${card.last4} set as primary');
  }

  Future<void> _confirmRemoveCard(_PaymentCard card) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove payment method'),
            content: Text('Delete ${card.brand} ending in ${card.last4}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldDelete) return;

    setState(() {
      _cards.remove(card);
      if (_cards.isNotEmpty && !_cards.any((c) => c.isPrimary)) {
        _cards[0] = _cards[0].copyWith(isPrimary: true);
      }
    });

    _showSnackBar('Payment method removed');
  }

  Future<void> _openCardForm({_PaymentCard? card}) async {
    final brandController = TextEditingController(text: card?.brand ?? '');
    final last4Controller = TextEditingController(text: card?.last4 ?? '');
    final expiryController = TextEditingController(text: card?.expiry ?? '');
    bool isPrimary = card?.isPrimary ?? false;

    final responsive = context.responsive;
    final loc = context.loc;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + responsive.spacing(20),
            left: responsive.spacing(20),
            right: responsive.spacing(20),
            top: responsive.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card == null ? loc.addPaymentMethodCta : 'Edit payment method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: responsive.spacing(16)),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(labelText: 'Card brand'),
              ),
              SizedBox(height: responsive.spacing(12)),
              TextField(
                controller: last4Controller,
                decoration: const InputDecoration(labelText: 'Last 4 digits'),
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              SizedBox(height: responsive.spacing(4)),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
                keyboardType: TextInputType.datetime,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: isPrimary,
                onChanged: (value) {
                  setState(() {
                    isPrimary = value ?? false;
                  });
                },
                title: const Text('Set as primary'),
              ),
              SizedBox(height: responsive.spacing(12)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (brandController.text.isEmpty ||
                        last4Controller.text.length != 4 ||
                        expiryController.text.isEmpty) {
                      _showSnackBar('Please complete all card details.');
                      return;
                    }

                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.spacing(12),
                    ),
                    child: Text(card == null ? loc.addPaymentMethodCta : 'Save changes'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != true) return;

    setState(() {
      if (isPrimary) {
        for (var i = 0; i < _cards.length; i++) {
          _cards[i] = _cards[i].copyWith(isPrimary: false);
        }
      }

      final newCard = _PaymentCard(
        brand: brandController.text,
        last4: last4Controller.text,
        expiry: expiryController.text,
        color: card?.color ?? const Color(0xFF2563EB),
        isPrimary: isPrimary || (_cards.isEmpty && card == null),
      );

      if (card == null) {
        _cards.add(newCard);
        _showSnackBar('Card added successfully');
      } else {
        final index = _cards.indexOf(card);
        if (index != -1) {
          _cards[index] = newCard;
          _showSnackBar('Card updated');
        }
      }
    });
  }

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
                child: _PaymentCardWidget(
                  card: card,
                  onEdit: () => _openCardForm(card: card),
                  onDelete: () => _confirmRemoveCard(card),
                  onMakePrimary: card.isPrimary ? null : () => _markAsPrimary(card),
                ),
              ),
            ),
            if (_cards.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
                child: Text(
                  'No payment methods yet. Add one to continue.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            SizedBox(height: responsive.spacing(12)),
            ElevatedButton.icon(
              onPressed: () => _openCardForm(),
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
  const _PaymentCardWidget({
    required this.card,
    required this.onEdit,
    required this.onDelete,
    this.onMakePrimary,
  });

  final _PaymentCard card;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMakePrimary;

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
              if (card.isPrimary)
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
                  onPressed: onEdit,
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
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(loc.removeAction),
                ),
              ),
            ],
          ),
          if (onMakePrimary != null) ...[
            SizedBox(height: responsive.spacing(10)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                onPressed: onMakePrimary,
                child: const Text('Make primary'),
              ),
            ),
          ]
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
    required this.isPrimary,
  });

  final String brand;
  final String last4;
  final String expiry;
  final Color color;
  final bool isPrimary;

  _PaymentCard copyWith({
    String? brand,
    String? last4,
    String? expiry,
    Color? color,
    bool? isPrimary,
  }) {
    return _PaymentCard(
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expiry: expiry ?? this.expiry,
      color: color ?? this.color,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
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
