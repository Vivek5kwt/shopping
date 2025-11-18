import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shop/constants.dart';

class CreativityView extends StatefulWidget {
  const CreativityView({
    super.key,
    required this.products,
    this.onProductTap,
  });

  final List<Map<String, dynamic>> products;
  final ValueChanged<Map<String, dynamic>>? onProductTap;

  @override
  State<CreativityView> createState() => _CreativityViewState();
}

class _CreativityViewState extends State<CreativityView> {
  late final PageController _pageController;
  double _currentPage = 0;

  static const List<List<Color>> _gradients = [
    [Color(0xFFFFF1F2), Color(0xFFFFD1DC)],
    [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
    [Color(0xFFE6FFFA), Color(0xFFB2F5EA)],
    [Color(0xFFEDE9FE), Color(0xFFDDD6FE)],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: const Text(
          'No creative picks yet. Continue exploring to unlock personalized stories.',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.products.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final product = widget.products[index];
              final gradient = _gradients[index % _gradients.length];
              final isFocused = (index - _currentPage).abs() < 0.5;

              return AnimatedPadding(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: isFocused ? 12 : 26,
                ),
                child: GestureDetector(
                  onTap: widget.onProductTap != null
                      ? () => widget.onProductTap!(product)
                      : null,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Iconsax.flash, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  product['sold'] == true ? 'Sold out look' : 'Fresh drop',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                child: product['image'] != null
                                    ? Image.asset(
                                        product['image'],
                                        fit: BoxFit.cover,
                                      )
                                    : const Center(
                                        child: Icon(
                                          Iconsax.gallery,
                                          size: 40,
                                          color: Colors.black45,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product['title'] ?? 'Unnamed',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${(product['price'] ?? 0).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(widget.products.length, (index) {
            final isActive = (index - _currentPage).abs() < 0.5;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 6,
              width: isActive ? 18 : 6,
              decoration: BoxDecoration(
                color: isActive ? Colors.black87 : Colors.black26,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
