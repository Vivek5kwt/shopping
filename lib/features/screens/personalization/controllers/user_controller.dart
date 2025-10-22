// import 'package:ecom/data/repositories/auth/authentication_repositories.dart';
// import 'package:ecom/data/repositories/auth/user/user_repository.dart';
// import 'package:ecom/features/authentication/models/user_model.dart';
// import 'package:ecom/features/personalization/view/delete_user_account_box.dart';
// import 'package:ecom/routes/routes.dart';
// import 'package:ecom/utils/constants/image_strings.dart';
// import 'package:ecom/utils/helpers/network_manager.dart';
// import 'package:ecom/utils/popups/full_screen_loader.dart';
// import 'package:ecom/utils/popups/loaders.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class UserController with ChangeNotifier {
//   final AuthenticationProvider _auth = AuthenticationProvider();
//   final UserRepository userRepo = UserRepository();
//   UserModel _user = UserModel.empty();
//   bool _isLoading = false;
//   bool _imageUloading = false;
//   bool hidepassword = true;
//   final verifyEmail = TextEditingController();
//   final verifyPassword = TextEditingController();
//   final GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
//   // Getter for user
//   UserModel get user => _user;
//   bool get isLoading => _isLoading;
//   bool get imageUloading => _imageUloading;

//   // Constructor to initialize and fetch user data
//   UserController() {
//     fetchUserRecord();
//   }
//   void toggelPassword() {
//     hidepassword = !hidepassword;
//     notifyListeners();
//   }

//   Future<void> savedUserRecord(
//       BuildContext context, UserCredential? userCredential) async {
//     try {
//       if (userCredential != null) {
//         final uid = userCredential.user!.uid;

//         final doc = await userRepo.db.collection("Users").doc(uid).get();

//         if (!doc.exists) {
//           // Convert Name to first and last Name..

//           final nameParts =
//               UserModel.nameParts(userCredential.user!.displayName ?? '');
//           final username = UserModel.generateUserName(
//               userCredential.user!.displayName ?? '');

//           // Map data..
//           final user = UserModel(
//               id: userCredential.user!.uid,
//               firstName: nameParts[0],
//               lastName:
//                   nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
//               userName: username,
//               email: userCredential.user!.email ?? '',
//               phoneNumber: userCredential.user!.phoneNumber ?? '',
//               profilePicture: userCredential.user!.photoURL ?? '');

//           // Save User data...
//           await userRepo.saveUser(user);
//         }

//         // Refresh local user state
//         await fetchUserRecord();
//       }
//     } catch (e) {
//       TLoaders.errorSnackBar(
//           context: context,
//           title: "Data not saved",
//           message:
//               " Something went wrong while saving your information. You can re-save your data in your Profile.");
//     }
//   }
//   // Delete Account Popup Warning...

//   void showDeleteAccountConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext dialogContext) {
//         // Use dialogContext inside the builder
//         return DeleteAccountDialog(
//           onDelete: () {
//             // Store the context before any navigation
//             final currentContext = dialogContext;

//             // Close the dialog first
//             Navigator.of(dialogContext).pop();

//             // Then delete account with the stored context
//             deleteAccount(currentContext);
//             print('Account deletion confirmed');
//           },
//           onCancel: () {
//             print('Account deletion canceled');
//             Navigator.of(dialogContext).pop();
//           },
//         );
//       },
//     );
//   }

//   //***---- Delete User Account -----***/

//   void deleteAccount(BuildContext context) async {
//     try {
//       TFullScreenLoader.openLoadingDialog(
//           context, "Processing...", TImages.docerAnimation);
//       final provider =
//           _auth.authUser!.providerData.map((e) => e.providerId).first;

//       if (provider.isNotEmpty) {
//         // if user from Google sign in...
//         if (provider == "google.com") {
//           await _auth.signInWithGoogle();
//           await _auth.deleteUserAccount();
//           TFullScreenLoader.stopLoading();
// // After successful deletion, show a nice goodbye message
//           TLoaders.successSnackBar(
//               context: context,
//               title: "Account Deleted",
//               message:
//                   "Your account has been successfully deleted. We're sad to see you go! You're welcome back anytime.");
//           // // Use the provided context
//           // Navigator.of(context).pushReplacement(
//           //     MaterialPageRoute(builder: (_) => const LoginPage()));
//           Get.offAllNamed(AppRoutes.login);
//         } else if (provider == "password") {
//           TFullScreenLoader.stopLoading();
//           Get.offAllNamed(AppRoutes.reAuthentications);

//           // // Use the provided context
//           // Navigator.of(context).pushReplacement(
//           //     MaterialPageRoute(builder: (_) => const ReAuthentication()));
//         }
//       }
//     } catch (e) {
//       TFullScreenLoader.stopLoading();
//       Get.offAllNamed(AppRoutes.upateProfile);
//       // // Use the provided context
//       // Navigator.of(context).pushReplacement(
//       //     MaterialPageRoute(builder: (context) => const UpdateProfile()));

//       TLoaders.errorSnackBar(
//           context: context, title: "Oh Snap!", message: e.toString());
//     }
//   }

//   //*** ------- Re auth User When deleting Account -----***/

//   Future<void> reAuthenticationUser(BuildContext context) async {
//     try {
//       if (!reAuthFormKey.currentState!.validate()) {
//         return;
//       }

//       TFullScreenLoader.openLoadingDialog(
//           context, "Processing...", TImages.docerAnimation);
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

//       await _auth.reAuthUser(
//           verifyEmail.text.trim(), verifyPassword.text.trim());
//       await _auth.deleteUserAccount();
//       TFullScreenLoader.stopLoading();
//       // After successful deletion, show a nice goodbye message
//       TLoaders.successSnackBar(
//           context: context,
//           title: "Account Deleted",
//           message:
//               "Your account has been successfully deleted. We're sad to see you go! You're welcome back anytime.");
//       // Future.microtask(() {
//       //   Navigator.pushReplacement(context,
//       //       MaterialPageRoute(builder: (context) => const LoginPage()));
//       //});
//       Get.offAllNamed(AppRoutes.login);
//     } catch (e) {
//       TFullScreenLoader.stopLoading();
//       Get.offAllNamed(AppRoutes.reAuthentications);
//       // Future.microtask(() {
//       //   Navigator.pushReplacement(context,
//       //       MaterialPageRoute(builder: (context) => const ReAuthentication()));
//       // });
//       TLoaders.errorSnackBar(
//           context: context, title: "Oh Snap!", message: e.toString());
//     }
//   }

//   //**** ------ Fetch User Record form FireStore ------****/

//   Future<void> fetchUserRecord() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       // Properly await the Future
//       final data = await userRepo.fetchUser();
//       _user = data;

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       // Error handling
//     }
//   }

//   // Upload User Profile image...

//   uploadUserProfilePicture(BuildContext context) async {
//     try {
//       final image = await ImagePicker().pickImage(
//           source: ImageSource.gallery,
//           imageQuality: 70,
//           maxWidth: 512,
//           maxHeight: 512);
//       if (image != null) {
//         _imageUloading = true;
//         notifyListeners();
//         final imageUrl =
//             await userRepo.uploadImage("Users/Images/Profile", image);
//         // Update User Image Record...

//         Map<String, dynamic> json = {"ProfilePicture": imageUrl};
//         await userRepo.updateSingleField(json);
//         // Get the Provider instance instead of using your local instance
//         final providerUserController =
//             Provider.of<UserController>(context, listen: false);
//         providerUserController.user.profilePicture = imageUrl;
//         providerUserController.notifyListeners();
//         _imageUloading = false;
//         // show success Message...

//         TLoaders.successSnackBar(
//             context: context,
//             title: "Congratulations",
//             message: "Your Profile Image has been Updated.");
//       }
//     } catch (e) {
//       _imageUloading = false;
//       // Show error message
//       TLoaders.errorSnackBar(
//           context: context, title: "Oh Snap!", message: e.toString());
//     }
//   }
// }
