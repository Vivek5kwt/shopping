import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  final List<_AddressItem> _addresses = const [
    const _AddressItem(
      title: 'Home',
      subtitle: '221B Baker Street, London, UK',
      phone: '+44 1234 567 890',
      isDefault: true,
      tagColor: const Color(0xFF3B82F6),
    ),
    const _AddressItem(
      title: 'Work',
      subtitle: '17 Hudson Yards, New York, NY',
      phone: '+1 212-555-9876',
      isDefault: false,
      tagColor: const Color(0xFF10B981),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addresses),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          children: [
            _HeaderMessage(
              title: loc.addresses,
              subtitle: loc.addressesSubtitle,
            ),
            SizedBox(height: responsive.spacing(20)),
            ..._addresses.map(
              (address) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(16)),
                child: _AddressCard(address: address),
              ),
            ),
            SizedBox(height: responsive.spacing(12)),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
                child: Text(loc.addAddressCta),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address});

  final _AddressItem address;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final loc = context.loc;

    return Container(
      padding: responsive.padding(all: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsive.spacing(12),
            offset: Offset(0, responsive.spacing(4)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.spacing(12),
                  vertical: responsive.spacing(6),
                ),
                decoration: BoxDecoration(
                  color: address.tagColor.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(responsive.borderRadius(20)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.place,
                      color: address.tagColor,
                      size: responsive.iconSize(16),
                    ),
                    SizedBox(width: responsive.spacing(6)),
                    Text(
                      address.title,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: address.tagColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing(12),
                    vertical: responsive.spacing(4),
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(responsive.borderRadius(20)),
                  ),
                  child: Text(
                    loc.primaryBadge,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            address.subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Row(
            children: [
              Icon(Icons.phone, size: responsive.iconSize(16)),
              SizedBox(width: responsive.spacing(6)),
              Expanded(
                child: Text(
                  address.phone,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(12)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(loc.editProfile),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: OutlinedButton.icon(
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

class _AddressItem {
  const _AddressItem({
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.isDefault,
    required this.tagColor,
  });

  final String title;
  final String subtitle;
  final String phone;
  final bool isDefault;
  final Color tagColor;
}

class _HeaderMessage extends StatelessWidget {
  const _HeaderMessage({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.07),
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
