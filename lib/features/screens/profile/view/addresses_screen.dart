import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late List<_AddressItem> _addresses;
  int _addressCounter = 0;

  @override
  void initState() {
    super.initState();
    _addresses = [
      _AddressItem(
        id: 'home',
        title: 'Home',
        subtitle: '221B Baker Street, London, UK',
        phone: '+44 1234 567 890',
        isDefault: true,
        tagColor: const Color(0xFF3B82F6),
      ),
      _AddressItem(
        id: 'work',
        title: 'Work',
        subtitle: '17 Hudson Yards, New York, NY',
        phone: '+1 212-555-9876',
        isDefault: false,
        tagColor: const Color(0xFF10B981),
      ),
    ];
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _setDefaultAddress(String id) {
    setState(() {
      _addresses = _addresses
          .map((address) => address.copyWith(isDefault: address.id == id))
          .toList();
    });
    final addressTitle =
        _addresses.firstWhere((element) => element.id == id).title;
    _showSnackBar('$addressTitle set as default');
  }

  Future<void> _confirmDeleteAddress(_AddressItem address) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove address'),
            content: Text('Delete ${address.title}?'),
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
      _addresses.removeWhere((item) => item.id == address.id);
      if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
        _addresses[0] = _addresses[0].copyWith(isDefault: true);
      }
    });

    _showSnackBar('Address removed');
  }

  Future<void> _openAddressForm({_AddressItem? address}) async {
    final responsive = context.responsive;
    final loc = context.loc;

    final titleController = TextEditingController(text: address?.title ?? '');
    final subtitleController =
        TextEditingController(text: address?.subtitle ?? '');
    final phoneController = TextEditingController(text: address?.phone ?? '');
    bool isDefault = address?.isDefault ?? false;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                responsive.spacing(20),
            left: responsive.spacing(20),
            right: responsive.spacing(20),
            top: responsive.spacing(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  address == null ? loc.addAddressCta : 'Edit address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: responsive.spacing(16)),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Label (Home, Work)'),
              ),
              SizedBox(height: responsive.spacing(12)),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Full address'),
              ),
              SizedBox(height: responsive.spacing(12)),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: isDefault,
                onChanged: (value) {
                  setState(() {
                    isDefault = value ?? false;
                  });
                },
                title: const Text('Set as default'),
              ),
              SizedBox(height: responsive.spacing(12)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        subtitleController.text.isEmpty ||
                        phoneController.text.isEmpty) {
                      _showSnackBar('Please complete all address details.');
                      return;
                    }

                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: responsive.spacing(12),
                    ),
                    child: Text(address == null ? loc.addAddressCta : 'Save changes'),
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
      if (isDefault) {
        _addresses =
            _addresses.map((a) => a.copyWith(isDefault: false)).toList();
      }

      final newAddress = _AddressItem(
        id: address?.id ?? 'addr_${_addressCounter++}',
        title: titleController.text,
        subtitle: subtitleController.text,
        phone: phoneController.text,
        isDefault: isDefault || (_addresses.isEmpty && address == null),
        tagColor: address?.tagColor ?? const Color(0xFF3B82F6),
      );

      if (address == null) {
        _addresses.add(newAddress);
        _showSnackBar('Address added');
      } else {
        final index = _addresses.indexWhere((a) => a.id == address.id);
        if (index != -1) {
          _addresses[index] = newAddress;
          _showSnackBar('Address updated');
        }
      }
    });
  }

  void _copyAddress(_AddressItem address) {
    Clipboard.setData(ClipboardData(text: address.subtitle));
    _showSnackBar('Address copied to clipboard');
  }

  void _openNavigation(_AddressItem address) {
    _showSnackBar('Navigation to ${address.title} is coming soon.');
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              loc.addresses,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: responsive.spacing(2)),
            Text(
              loc.addressesSubtitle,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          children: [
            _AddressHero(responsive: responsive),
            SizedBox(height: responsive.spacing(18)),
            _QuickActions(
              responsive: responsive,
              onSetDefault: () {
                if (_addresses.isNotEmpty) {
                  _setDefaultAddress(_addresses.first.id);
                }
              },
              onShare: () {
                if (_addresses.isNotEmpty) {
                  _copyAddress(_addresses.first);
                }
              },
              onViewHistory: () =>
                  _showSnackBar('Recent deliveries will appear here soon.'),
            ),
            SizedBox(height: responsive.spacing(20)),
            _HeaderMessage(
              title: loc.addresses,
              subtitle: loc.addressesSubtitle,
            ),
            SizedBox(height: responsive.spacing(20)),
            ..._addresses.map(
              (address) => Padding(
                padding: EdgeInsets.only(bottom: responsive.spacing(16)),
                child: _AddressCard(
                  address: address,
                  onDirections: () => _openNavigation(address),
                  onShare: () => _copyAddress(address),
                  onEdit: () => _openAddressForm(address: address),
                  onDelete: () => _confirmDeleteAddress(address),
                  onMakeDefault:
                      address.isDefault ? null : () => _setDefaultAddress(address.id),
                ),
              ),
            ),
            if (_addresses.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
                child: Text(
                  'No addresses yet. Add one to keep deliveries on track.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            SizedBox(height: responsive.spacing(12)),
            ElevatedButton.icon(
              onPressed: () => _openAddressForm(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: responsive.spacing(14)),
                textStyle: theme.textTheme.titleMedium,
              ),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(loc.addAddressCta),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.onDirections,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
    this.onMakeDefault,
  });

  final _AddressItem address;
  final VoidCallback onDirections;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMakeDefault;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final loc = context.loc;

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: responsive.padding(all: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(24)),
        gradient: LinearGradient(
          colors: [
            address.tagColor.withOpacity(0.08),
            colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: address.tagColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: responsive.spacing(18),
            offset: Offset(0, responsive.spacing(6)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _AddressTypeChip(
                responsive: responsive,
                address: address,
              ),
              const Spacer(),
              if (address.isDefault)
                _DefaultBadge(
                  responsive: responsive,
                  loc: loc,
                ),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),
          Text(
            address.subtitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(14)),
          Divider(color: colorScheme.outline.withOpacity(0.2)),
          SizedBox(height: responsive.spacing(14)),
          Wrap(
            spacing: responsive.spacing(10),
            runSpacing: responsive.spacing(10),
            children: [
              _ActionChip(
                icon: Icons.navigation_outlined,
                label: 'Directions',
                onTap: onDirections,
                responsive: responsive,
              ),
              _ActionChip(
                icon: Icons.share_location_outlined,
                label: 'Share',
                onTap: onShare,
                responsive: responsive,
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(16)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(loc.editProfile),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(loc.removeAction),
                ),
              ),
            ],
          ),
          if (onMakeDefault != null) ...[
            SizedBox(height: responsive.spacing(12)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onMakeDefault,
                child: const Text('Set as default'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddressTypeChip extends StatelessWidget {
  const _AddressTypeChip({
    required this.responsive,
    required this.address,
  });

  final ResponsiveUtils responsive;
  final _AddressItem address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(14),
        vertical: responsive.spacing(6),
      ),
      decoration: BoxDecoration(
        color: address.tagColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.place,
            color: address.tagColor,
            size: responsive.iconSize(16),
          ),
          SizedBox(width: responsive.spacing(6)),
          Text(
            address.title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: address.tagColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge({required this.responsive, required this.loc});

  final ResponsiveUtils responsive;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(12),
        vertical: responsive.spacing(4),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: responsive.iconSize(16),
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: responsive.spacing(4)),
          Text(
            loc.primaryBadge,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.responsive,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ResponsiveUtils responsive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
      borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.spacing(14),
            vertical: responsive.spacing(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: responsive.iconSize(18)),
              SizedBox(width: responsive.spacing(6)),
              Text(label, style: theme.textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressItem {
  const _AddressItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.isDefault,
    required this.tagColor,
  });

  final String id;
  final String title;
  final String subtitle;
  final String phone;
  final bool isDefault;
  final Color tagColor;

  _AddressItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? phone,
    bool? isDefault,
    Color? tagColor,
  }) {
    return _AddressItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      tagColor: tagColor ?? this.tagColor,
    );
  }
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

class _AddressHero extends StatelessWidget {
  const _AddressHero({required this.responsive});

  final ResponsiveUtils responsive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: responsive.padding(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(28)),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.35),
            blurRadius: responsive.spacing(24),
            offset: Offset(0, responsive.spacing(10)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ready for your next delivery?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: responsive.spacing(6)),
                Text(
                  'Keep your addresses updated to get orders faster and at the right doorstep.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: responsive.spacing(16)),
          Container(
            padding: responsive.padding(all: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
            ),
            child: Icon(
              Icons.map_outlined,
              color: Colors.white,
              size: responsive.iconSize(32),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.responsive,
    required this.onSetDefault,
    required this.onShare,
    required this.onViewHistory,
  });

  final ResponsiveUtils responsive;
  final VoidCallback onSetDefault;
  final VoidCallback onShare;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 420;
        final actions = [
          _QuickActionData(
            icon: Icons.home_work_outlined,
            title: 'Default location',
            subtitle: 'Set preferred delivery spot',
            color: theme.colorScheme.primary,
            onTap: onSetDefault,
          ),
          _QuickActionData(
            icon: Icons.qr_code_scanner,
            title: 'Share code',
            subtitle: 'Send details to courier',
            color: theme.colorScheme.secondary,
            onTap: onShare,
          ),
          _QuickActionData(
            icon: Icons.history_rounded,
            title: 'Recent drops',
            subtitle: 'View last deliveries',
            color: theme.colorScheme.tertiary,
            onTap: onViewHistory,
          ),
        ];

        return Wrap(
          spacing: responsive.spacing(12),
          runSpacing: responsive.spacing(12),
          children: actions
              .map(
                (action) => SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - responsive.spacing(12) * 2) / 3
                      : double.infinity,
                  child: _QuickActionCard(
                    action: action,
                    responsive: responsive,
                    onTap: action.onTap,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.action,
    required this.responsive,
    required this.onTap,
  });

  final _QuickActionData action;
  final ResponsiveUtils responsive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
        onTap: onTap,
        child: Container(
          padding: responsive.padding(all: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: responsive.padding(all: 10),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.15),
                  borderRadius:
                      BorderRadius.circular(responsive.borderRadius(16)),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: responsive.iconSize(20),
                ),
              ),
              SizedBox(width: responsive.spacing(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    Text(
                      action.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
}
