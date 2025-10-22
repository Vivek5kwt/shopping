import 'package:flutter/material.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/screens/personalization/controllers/address_controller.dart';
import 'package:shop/utils/appbar/custom_appbar.dart';
import 'package:shop/utils/sizes/size.dart';
import 'package:shop/utils/validators/validators.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddressController, AuthProvider>(
      builder: (context, controller, authProvider, child) {
        return Scaffold(
          appBar: const CustomeAppbar(
            showbackArrow: true,
            title: Text('Add new address'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),

              child: Form(
                key: controller.addressFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.name,
                      validator: (value) =>
                          TValidator.validateEmptyText('Name', value),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.phoneNumber,
                      validator: TValidator.validatePhoneNumberSimple,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+92 3489335682',
                        prefixIcon: Icon(Iconsax.mobile),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.street,
                            validator: (value) =>
                                TValidator.validateEmptyText("Street", value),
                            decoration: const InputDecoration(
                              labelText: 'Street',
                              prefixIcon: Icon(Iconsax.building),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.postalCode,
                            validator: (value) => TValidator.validateEmptyText(
                              "Postal Code",
                              value,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Postal Code',
                              prefixIcon: Icon(Iconsax.code),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.city,
                            validator: (value) =>
                                TValidator.validateEmptyText("City", value),
                            decoration: const InputDecoration(
                              labelText: 'City',
                              prefixIcon: Icon(Iconsax.building),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                            controller: controller.state,
                            validator: (value) =>
                                TValidator.validateEmptyText("State", value),
                            decoration: const InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(Iconsax.activity),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.country,
                      validator: (value) =>
                          TValidator.validateEmptyText("Country", value),
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        prefixIcon: Icon(Iconsax.global),
                      ),
                    ),
                    const SizedBox(height: TSizes.defaultSpace),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.saveUserAddress(
                          context: context,
                          currentUser: authProvider.user!,
                          onUserUpdate: (updatedUser) {
                            authProvider.setUserFromModel(updatedUser);
                          },
                        ),
                        child: controller.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
