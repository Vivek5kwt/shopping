// // ViewAllProducts.dart - Fixed
// import 'package:ecom/common/widgets/layout/grid_layout.dart';
// import 'package:ecom/common/widgets/product/vertical_product_container.dart';
// import 'package:ecom/features/shop/controllers/product/all_product_controller.dart';
// import 'package:ecom/features/shop/models/product_model.dart';
// import 'package:ecom/utils/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ViewAllProducts extends StatefulWidget {
//   const ViewAllProducts({
//     super.key,
//     required this.product,
//   });
//   final List<ProductModel> product;

//   @override
//   State<ViewAllProducts> createState() => _ViewAllProductsState();
// }

// class _ViewAllProductsState extends State<ViewAllProducts> {
//   @override
//   void initState() {
//     super.initState();
//     // Move the assignment to initState instead of build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         final controller =
//             Provider.of<AllProductController>(context, listen: false);
//         controller.assignProducts(widget.product);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Dropdown button field..
//         Consumer<AllProductController>(
//           builder: (context, controller, _) {
//             return DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.sort),
//               ),
//               value: controller.sortSelection,
//               onChanged: (value) {
//                 if (value != null) {
//                   controller.sortProduct(value);
//                 }
//               },
//               items: const [
//                 DropdownMenuItem(value: "Name", child: Text("Name")),
//                 DropdownMenuItem(
//                     value: "Higher Price", child: Text("Higher Price")),
//                 DropdownMenuItem(
//                     value: "Lower Price", child: Text("Lower Price")),
//                 DropdownMenuItem(value: "Sales", child: Text("Sales")),
//                 DropdownMenuItem(value: "Newest", child: Text("Newest")),
//               ],
//             );
//           },
//         ),

//         const SizedBox(
//           height: TSizes.spaceBtwSections,
//         ),

//         Consumer<AllProductController>(
//           builder: (context, productController, _) {
//             return GridLayout(
//               itemCount: productController.products.length,
//               itemBuilder: (context, index) => VerticalProductContainer(
//                 productModel: productController.products[index],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
