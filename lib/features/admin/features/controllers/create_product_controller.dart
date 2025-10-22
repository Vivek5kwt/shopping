// Add Product Controller
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/data/services/admin_services.dart';
import 'package:shop/features/admin/features/controllers/get_product_controller.dart';
import 'package:shop/utils/loaders/snackbar.dart';

class AddProductController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<File> _images = [];

  // Text controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  // Selected category
  String _selectedCategory = '';
  String _selectedImage = '';

  String get selectedCategory => _selectedCategory;
  String get selectedImage => _selectedImage;
  List<File> get images => _images;

  // Loading state

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set selectedCategory(String? value) {
    _selectedCategory = value!;
    notifyListeners();
  }

  // Categories list
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Sports',
    'Toys',
    'Beauty',
    'Others',
  ];

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void selectImage() {
    // Image picker implementation would go here
    _selectedImage = 'selected'; // Placeholder
    Get.snackbar(
      'Image Selected',
      'Product image has been selected',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
    );
    notifyListeners();
  }

  Future<void> addProduct(BuildContext context) async {
    try {
      if (!formKey.currentState!.validate() && !_images.isNotEmpty) return;
      if (selectedCategory.isEmpty) {
        CustomSnackbars.showWarning(
          context,
          "⚠️ Heads Up!",
          'Please select a category',
        );
        return;
      }

      _isLoading = true;
      notifyListeners();

      final amdinService = AdminServices();
      await amdinService.addProducts(
        context: context,
        name: titleController.text,
        descriptions: descriptionController.text,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        category: _selectedCategory,
        images: _images,
      );
      // Clear form
      clearForm();
      _isLoading = false;

      notifyListeners();
      // ** Refresh the product list after successful addition**
      final getProductController = Provider.of<GetProductController>(
        context,
        listen: false,
      );
      await getProductController.getAllProdcuts(context);
      Get.back();
      CustomSnackbars.showSuccess(
        context,
        "🎉 All Set!",
        'Product added successfully!',
      );
    } catch (e) {
      debugPrint(
        " Error while uploading products controller : ${e.toString()}",
      );
      CustomSnackbars.showError(context, "❌ Oops!", 'Error adding product: $e');
    }
  }

  Future<List<File>> filePicker() async {
    List<File> images = [];

    try {
      final files = await FilePicker.platform.pickFiles(
        //  type: FileType.image,
        allowMultiple: true,
      );

      if (files != null && files.files.isNotEmpty) {
        for (int i = 0; i < files.files.length; i++) {
          images.add(File(files.files[i].path!));
        }
      }
    } catch (e) {
      debugPrint(" error while picking files : ${e.toString()}");
    }
    return images;
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final result = await filePicker();

      _images.assignAll(result);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(" Error while picking image : ${e.toString()}");
      CustomSnackbars.showError(context, "❌ Oops!", 'Error updating photo: $e');
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    quantityController.clear();
    _images.clear();
    _selectedCategory = '';
    _selectedImage = '';
  }
}
