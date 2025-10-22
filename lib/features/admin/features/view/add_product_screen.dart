import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/controllers/create_product_controller.dart';
import 'package:shop/responsive/responsiveness.dart';

// Add Product Screen
class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddProductController>(
      context,
      listen: false,
    );
    final bool isMobile = ResponsiveBreakpoint.isMobile(context);
    final double screenWidth = ResponsiveBreakpoint.getWidth(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B7280)),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.clearForm(),
            child: const Text(
              'Clear',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              _buildImageUploadSection(isMobile, screenWidth),
              const SizedBox(height: 24),

              // Product Details Section
              _buildProductDetailsSection(controller, isMobile),

              // Add some bottom padding for better UX
              SizedBox(height: isMobile ? 100 : 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(bool isMobile, double screenWidth) {
    return Consumer<AddProductController>(
      builder: (context, controller, child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Product Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),

                // Image Upload Container
                controller.images.isNotEmpty
                    ? SizedBox(
                        height: 300,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            final image = controller.images[index];
                            return Image.file(
                              image,
                              fit: BoxFit.cover,
                              height: 200,
                            );
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: () => controller.pickImages(context),
                        child: Container(
                          width: double.infinity,
                          height: isMobile ? 200 : 250,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFD1D5DB),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Upload Product Image',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'PNG, JPG up to 10MB',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductDetailsSection(
    AddProductController controller,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),

            // Title Field
            _buildTextFormField(
              controller: controller.titleController,
              label: 'Product Title',
              hint: 'Enter product title',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            _buildTextFormField(
              controller: controller.descriptionController,
              label: 'Description',
              hint: 'Enter product description',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Price and Quantity Row
            Row(
              children: [
                // Price Field
                Expanded(
                  child: _buildTextFormField(
                    controller: controller.priceController,
                    label: 'Price',
                    hint: '0.00',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Quantity Field
                Expanded(
                  child: _buildTextFormField(
                    controller: controller.quantityController,
                    label: 'Quantity',
                    hint: '0',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid quantity';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            _buildCategoryDropdown(),
            const SizedBox(height: 24),

            // Add Product Button
            _buildAddProductButton(isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Consumer<AddProductController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCategory.isEmpty
                    ? null
                    : controller.selectedCategory,
                hint: const Text(
                  'Select category',
                  style: TextStyle(color: Color(0xFF9CA3AF)),
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.category,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                items: controller.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedCategory = value ?? '';
                },
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddProductButton(bool isMobile) {
    return Consumer<AddProductController>(
      builder: (context, controller, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                controller.isLoading ? null : controller.addProduct(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 16 : 18,
                horizontal: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Add Product',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
