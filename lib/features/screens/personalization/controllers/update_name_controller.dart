// import 'package:ecom/data/repositories/auth/user/user_repository.dart';
// import 'package:ecom/features/personalization/controllers/user_controller.dart';
// import 'package:ecom/utils/constants/image_strings.dart';
// import 'package:ecom/utils/helpers/network_manager.dart';
// import 'package:ecom/utils/popups/full_screen_loader.dart';
// import 'package:ecom/utils/popups/loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// class UpdateNameController with ChangeNotifier {
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final UserController userController = UserController();
//   final UserRepository userRepo = UserRepository();
//   final GlobalKey<FormState> updateUserNamFormKey = GlobalKey<FormState>();

//   UpdateNameController() {
//     initiallizedNames();
//   }

//   Future<void> initiallizedNames() async {
//     firstName.text = userController.user.firstName;
//     lastName.text = userController.user.lastName;
//   }

//   Future<void> updateUserNames(BuildContext context) async {
//     try {
//       // Step 1: Form Validation first
//       if (!updateUserNamFormKey.currentState!.validate()) {
//         return;
//       }

//       // Step 3: Start loading animation ONLY if internet is connected
//       TFullScreenLoader.openLoadingDialog(context,
//           "We are processing your information...", TImages.docerAnimation);
//       final isConnected = await NetworkManager.instance.isConnected();
//       if (!isConnected) {
//         TFullScreenLoader.stopLoading();
//         Navigator.pop(context);
//         TLoaders.errorSnackBar(
//             context: context,
//             title: "Connection Error",
//             message: "No internet connection");
//         return;
//       }

//       try {
//         Map<String, dynamic> names = {
//           "FirstName": firstName.text.trim(),
//           "LastName": lastName.text.trim()
//         };

//         // Save into fireStore..
//         await userRepo.updateSingleField(names);

//         // Get the Provider instance instead of using your local instance
//         final providerUserController =
//             Provider.of<UserController>(context, listen: false);

//         // Update the Provider instance
//         providerUserController.user.firstName = firstName.text.trim();
//         providerUserController.user.lastName = lastName.text.trim();
//         providerUserController.notifyListeners();

//         // Remove the loader...
//         TFullScreenLoader.stopLoading();

//         // show success Message...
//         TLoaders.successSnackBar(
//             context: context,
//             title: "Congratulations",
//             message: "Your Name has been Updated.");

//         Navigator.pop(context);
//       } catch (e) {
//         // Handle errors in server operations
//         TFullScreenLoader.stopLoading();
//         TLoaders.errorSnackBar(
//             context: context, title: "Update Failed", message: e.toString());
//       }
//       notifyListeners();
//     } catch (e) {
//       // Make sure the loader is stopped
//       TFullScreenLoader.stopLoading();
//       Get.back();
//       // Show error message
//       TLoaders.errorSnackBar(
//           context: context, title: "Oh Snap!", message: e.toString());
//     }
//   }
// }
