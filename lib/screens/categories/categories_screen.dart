import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../models/category.dart';
import '../../services/product_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_card.dart';

class CategoriesScreen extends StatefulWidget {
  final String? initialCategoryId;

  const CategoriesScreen({super.key, this.initialCategoryId});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<ProductService>()
            .selectCategory(widget.initialCategoryId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final categories = productService.categories;
    final selectedCatId = productService.selectedCategoryId;
    final filteredProducts = productService.filteredProducts;

    final selectedCategory = categories.isNotEmpty
        ? categories.firstWhere(
            (c) => c.id == selectedCatId,
            orElse: () => categories.first,
          )
        : const Category(
            id: 'cat_all',
            name: 'Semua',
            icon: Icons.grid_view_rounded,
            description: 'Semua sayur & hasil tani',
          );

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: CustomAppBar(
        title: 'Kategori Sayuran',
        showBackButton: Navigator.canPop(context),
      ),
      body: Column(
        children: [
          // Horizontal Category Chip Bar
          Container(
            color: KebuninColors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat.id == selectedCatId;

                  return InkWell(
                    onTap: () {
                      productService.selectCategory(cat.id);
                    },
                    borderRadius: BorderRadius.circular(KebuninRadius.pill),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? KebuninColors.forestGreen
                            : KebuninColors.warmCream,
                        borderRadius: BorderRadius.circular(KebuninRadius.pill),
                        border: Border.all(
                          color: isSelected
                              ? KebuninColors.forestGreen
                              : KebuninColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat.icon,
                            size: 16,
                            color: isSelected
                                ? KebuninColors.white
                                : KebuninColors.forestGreen,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: isSelected
                                  ? KebuninColors.white
                                  : KebuninColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Category Header Info Banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedCategory.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: KebuninColors.charcoal,
                      ),
                    ),
                    Text(
                      selectedCategory.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: KebuninColors.mutedGrey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: KebuninColors.white,
                    borderRadius: BorderRadius.circular(KebuninRadius.pill),
                    border: Border.all(color: KebuninColors.border),
                  ),
                  child: Text(
                    '${filteredProducts.length} Sayur',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: KebuninColors.forestGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState(context)
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: KebuninColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KebuninColors.border),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 40,
                color: KebuninColors.mutedGrey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada sayur di kategori ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: KebuninColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Petani sedang menyiapkan panen berikutnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: KebuninColors.mutedGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
