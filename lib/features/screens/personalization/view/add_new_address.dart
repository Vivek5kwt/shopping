import 'package:flutter/material.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/screens/personalization/controllers/address_controller.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/validators/validators.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = context.loc;

    return Consumer2<AddressController, AuthProvider>(
      builder: (context, controller, authProvider, child) {
        return Scaffold(
          backgroundColor: colorScheme.surfaceVariant.withOpacity(0.2),
          appBar: CustomeAppbar(
            showbackArrow: true,
            title: Text(loc.addAddressCta),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AddressHeroCard(theme: theme),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius:
                          BorderRadius.circular(TSizes.cardRadiusLg * 1.2),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(TSizes.lg),
                      child: Form(
                        key: controller.addressFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact details',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            _ThemedTextField(
                              controller: controller.name,
                              label: 'Full name',
                              icon: Iconsax.user,
                              validator: (value) =>
                                  TValidator.validateEmptyText('Name', value),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                            _ThemedTextField(
                              controller: controller.phoneNumber,
                              label: 'Phone number',
                              hintText: '+92 3489335682',
                              keyboardType: TextInputType.phone,
                              icon: Iconsax.mobile,
                              validator: TValidator.validatePhoneNumberSimple,
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Text(
                              'Location details',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            _ThemedTextField(
                              controller: controller.street,
                              label: 'Street & house number',
                              icon: Iconsax.building,
                              validator: (value) =>
                                  TValidator.validateEmptyText('Street', value),
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                            Row(
                              children: [
                                Expanded(
                                  child: _ThemedTextField(
                                    controller: controller.city,
                                    label: 'City',
                                    icon: Iconsax.building,
                                    validator: (value) =>
                                        TValidator.validateEmptyText(
                                      'City',
                                      value,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: TSizes.spaceBtwInputFields),
                                Expanded(
                                  child: _ThemedTextField(
                                    controller: controller.state,
                                    label: 'State / Region',
                                    icon: Iconsax.activity,
                                    validator: (value) =>
                                        TValidator.validateEmptyText(
                                      'State',
                                      value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwInputFields),
                            Row(
                              children: [
                                Expanded(
                                  child: _ThemedTextField(
                                    controller: controller.postalCode,
                                    label: 'Postal code',
                                    icon: Iconsax.code,
                                    validator: (value) =>
                                        TValidator.validateEmptyText(
                                      'Postal Code',
                                      value,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: TSizes.spaceBtwInputFields),
                                Expanded(
                                  child: _ThemedTextField(
                                    controller: controller.country,
                                    label: 'Country',
                                    icon: Iconsax.global,
                                    validator: (value) =>
                                        TValidator.validateEmptyText(
                                      'Country',
                                      value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : () => controller.saveUserAddress(
                                          context: context,
                                          currentUser: authProvider.user!,
                                          onUserUpdate: (updatedUser) {
                                            authProvider
                                                .setUserFromModel(updatedUser);
                                          },
                                        ),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: TSizes.md,
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  textStyle: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: controller.isLoading
                                      ? Row(
                                          key: const ValueKey('loading'),
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: TSizes.sm),
                                            Text('Saving...'),
                                          ],
                                        )
                                      : Row(
                                          key: const ValueKey('cta'),
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Iconsax.location_add5,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: TSizes.sm),
                                            Text(loc.addAddressCta),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemedTextField extends StatelessWidget {
  const _ThemedTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: theme.colorScheme.primary),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
        ),
      ),
    );
  }
}

class _AddressHeroCard extends StatelessWidget {
  const _AddressHeroCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TSizes.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg * 1.4),
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
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 16),
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
                  'Keep your deliveries on track',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.sm),
                Text(
                  'Add a precise address so couriers can reach you faster and without delays.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TSizes.lg),
          Container(
            padding: const EdgeInsets.all(TSizes.md),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
            ),
            child: const Icon(
              Iconsax.location5,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
