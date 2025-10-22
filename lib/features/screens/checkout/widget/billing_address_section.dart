import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';
import 'package:shop/features/screens/personalization/view/add_new_address.dart';
import 'package:shop/features/screens/personalization/widgets/address_parser.dart';
import 'package:shop/utils/section_header/sections_header.dart';
import 'package:shop/utils/sizes/size.dart';

class BillingAddressSection extends StatefulWidget {
  const BillingAddressSection({super.key});

  @override
  State<BillingAddressSection> createState() => _BillingAddressSectionState();
}

class _BillingAddressSectionState extends State<BillingAddressSection> {
  @override
  void initState() {
    super.initState();
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<UserController>(context, listen: false);
      controller.fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        final address = controller.user?.address ?? '';
        print("Address in billing : $address");

        // Check if address exists and is valid
        if (address.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Shipping Address',
                buttonTitle: 'Add',
                onPressed: () => Get.to(() => AddNewAddress()),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Text(
                "No address saved. Please add a shipping address.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          );
        }

        final addressData = AddressParser.parseAddress(address);

        // Check if parsing was successful (name won't be empty if valid)
        if (addressData['name']?.isEmpty ?? true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Shipping Address',
                buttonTitle: 'Fix',
                onPressed: () => Get.to(() => AddNewAddress()),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Text(
                "Invalid address format. Please update your address.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.orange),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Shipping Address',
              buttonTitle: 'Change',
              onPressed: () => Get.to(() => AddNewAddress()),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  addressData['name']!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.grey, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      addressData['phoneNumber']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_history,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${addressData['street']}, ${addressData['postalCode']}, ${addressData['city']}, ${addressData['state']}, ${addressData['country']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
