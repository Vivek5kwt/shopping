import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/auth/auth_provider.dart';
import 'package:shop/features/auth/model/user.dart';
import 'package:shop/features/auth/view/login_screen.dart';
import 'package:shop/data/repositories/api_repo.dart';
import 'package:shop/data/services/storage_services.dart';
import 'package:shop/features/controllers/products/favorite_controller.dart';
import 'package:shop/utils/enums/auth_enums.dart';
import 'package:shop/utils/loaders/snackbar.dart';
import 'package:shop/utils/local_storage/storage.dart';

class UserController with ChangeNotifier {
  UserModel? _user;
  AuthStatus _status = AuthStatus.loading;
  String _message = '';
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  bool _isUpdatingPhoto = false;
  File? _selectedImage;

  UserModel? get user => _user;
  AuthStatus get status => _status;
  String get message => _message;
  bool get isUpdatingPhoto => _isUpdatingPhoto;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  File? get selectedImage => _selectedImage;

  Future<void> fetchUser() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      final userId = await StorageService.getUserId();
      print("user id : $userId");

      if (userId == null) {
        _status = AuthStatus.unauthenticated;
        _message = 'No user ID found';
        notifyListeners();
        return;
      }

      final response = await ApiService.getUser(userId);

      if (response.success && response.data != null) {
        // The user data is nested under 'user' key in the response
        final userData = response.data['user'];

        if (userData != null) {
          _user = UserModel.fromJson(userData);

          _message = response.message;
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
          _message = 'No user data found in response';
        }
      } else {
        _status = AuthStatus.unauthenticated;
        _message = response.message;
      }

      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _message = 'Fetching user failed: ${e.toString()}';
      print(_message);
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final favoriteController = Provider.of<FavoriteController>(
        context,
        listen: false,
      );

      // Clear favorites first
      favoriteController.clearFavorites();

      // Then logout the user
      await authProvider.logout();
      await _clearAuthData();
      Get.offAll(() => LoginScreen());
      CustomSnackbars.showSuccess(
        context,
        "👋 See You Soon!",
        "You've logged out safely.",
      );
      notifyListeners();
    } catch (e) {
      _message = 'Logout failed: ${e.toString()}';
      CustomSnackbars.showError(context, "❌ Oops!", _message);
      print('Logout API call failed: $_message');
    }
  }

  // Pick image file using file picker
  Future<File?> filePicker() async {
    File? image;

    try {
      final files = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (files != null && files.files.isNotEmpty) {
        image = File(files.files.first.path!);
      }
    } catch (e) {
      debugPrint("Error while picking files: ${e.toString()}");
    }
    return image;
  }

  // Pick image and store temporarily
  Future<void> pickImage(BuildContext context) async {
    try {
      final result = await filePicker();

      if (result != null) {
        _selectedImage = result;
        notifyListeners();

        CustomSnackbars.showSuccess(
          context,
          "✅ Image Selected",
          "Tap update to upload your new profile picture",
        );
      }
    } catch (e) {
      debugPrint("Error while picking image: ${e.toString()}");
      CustomSnackbars.showError(
        context,
        "❌ Oops!",
        'Error selecting image: $e',
      );
    }
  }

  // Pick and upload profile picture in one function
  Future<void> updateProfilePhoto(BuildContext context) async {
    try {
      _isUpdatingPhoto = true;
      notifyListeners();

      // Pick image
      final imageFile = await filePicker();

      if (imageFile == null) {
        CustomSnackbars.showError(
          context,
          "❌ No Image Selected",
          'Please select an image first',
        );
        return;
      }

      // Upload to server
      final response = await ApiService.updateProfilePic(
        context: context,
        images: imageFile,
      );
      print("updating profile response:${response.success}");
      print("updating profile response data:${response.data}");

      if (response.success) {
        // Update user data if needed
        if (_user != null && response.data != null) {
          _user = _user!.copyWith(profilePic: response.data['profilePic']);
        }

        _selectedImage = imageFile;

        CustomSnackbars.showSuccess(
          context,
          "🎉 All Set!",
          'Profile picture updated successfully!',
        );
      } else {
        CustomSnackbars.showError(
          context,
          "❌ Oops!",
          response.message ?? 'Upload failed',
        );
        print("Uploading response: ${response.message}");
      }
    } catch (e) {
      CustomSnackbars.showError(context, "❌ Oops!", 'Error updating photo: $e');
      _message = e.toString();
      print("Uploading picture error: $_message");
    } finally {
      _isUpdatingPhoto = false;
      notifyListeners();
    }
  }

  Future<void> _clearAuthData() async {
    await StorageService.clearAll();
    await TLocalStorage.instance().clearAll();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _message = '';
    _selectedImage = null;
  }

  void clearMessage() {
    _message = '';
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
