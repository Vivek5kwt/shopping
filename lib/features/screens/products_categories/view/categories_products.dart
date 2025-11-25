import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/admin/features/models/product_model.dart';
import 'package:shop/features/controllers/products/products_controller.dart';
import 'package:shop/utils/common/grid_layout.dart';
import 'package:shop/utils/product/vertical_product_container.dart';
import 'package:shop/utils/shimmer/product_shimmer.dart';
import 'package:shop/utils/sizes/size.dart';

enum SortOption { featured, name, priceLowHigh, priceHighLow }

class CategoriesProducts extends StatefulWidget {
  final String category;
  const CategoriesProducts({super.key, required this.category});

  @override
  State<CategoriesProducts> createState() => _CategoriesProductsState();
}

class _CategoriesProductsState extends State<CategoriesProducts> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _selectedSort = SortOption.featured;
  bool _inStockOnly = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load Products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<ProductsController>(
        context,
        listen: false,
      );
      controller.getCategoriesProducts(context, widget.category);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _getVisibleProducts(List<ProductModel> products) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = products.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.descriptions.toLowerCase().contains(query);

      final matchesStock = !_inStockOnly || product.quantity > 0;
      return matchesQuery && matchesStock;
    }).toList();

    switch (_selectedSort) {
      case SortOption.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.priceLowHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.featured:
        break;
    }

    return filtered;
  }

  String _sortLabel(SortOption option) {
    switch (option) {
      case SortOption.name:
        return 'Name (A-Z)';
      case SortOption.priceLowHigh:
        return 'Price: Low to High';
      case SortOption.priceHighLow:
        return 'Price: High to Low';
      case SortOption.featured:
      default:
        return 'Featured';
    }
  }

  Widget _buildFilters(BuildContext context, int totalCount, int visibleCount) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(TSizes.spaceBtwItems),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Chip(
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.08),
                    label: Text(
                      '$totalCount items',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.sm),
              Text(
                'Tune the list to quickly find what you need.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search within ${widget.category}',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    icon: const Icon(Icons.close),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TSizes.inputFieldRadius),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Wrap(
          spacing: TSizes.sm,
          runSpacing: TSizes.sm,
          children: [
            for (final option in SortOption.values)
              ChoiceChip(
                label: Text(_sortLabel(option)),
                selected: _selectedSort == option,
                onSelected: (_) => setState(() => _selectedSort = option),
              ),
            FilterChip(
              label: const Text('In stock only'),
              avatar: const Icon(Icons.inventory_2_outlined, size: 18),
              selected: _inStockOnly,
              onSelected: (value) => setState(() => _inStockOnly = value),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          _searchQuery.isEmpty && !_inStockOnly && _selectedSort == SortOption.featured
              ? 'Showing all $visibleCount products'
              : '$visibleCount products match your filters',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product grid sections..
              Consumer<ProductsController>(
                builder: (context, productController, child) {
                  if (productController.isLoading) {
                    return const VerticalProductShimmer();
                  }
                  if (productController.productList.isEmpty) {
                    return Center(
                      child: Text(
                        'No Products Found in ${widget.category} Category!',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    final visibleProducts =
                        _getVisibleProducts(productController.productList);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilters(
                          context,
                          productController.productList.length,
                          visibleProducts.length,
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections),
                        if (visibleProducts.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(TSizes.cardRadiusMd),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.filter_alt_off_outlined, size: 36),
                                const SizedBox(height: TSizes.sm),
                                Text(
                                  'No products match your filters.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: TSizes.xs),
                                Text(
                                  'Try clearing the search or switching sort options.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                ),
                              ],
                            ),
                          )
                        else
                          GridLayout(
                            itemCount: visibleProducts.length,
                            itemBuilder: (context, index) {
                              final product = visibleProducts[index];
                              return VerticalProductContainer(
                                productModel: product,
                              );
                            },
                          ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
