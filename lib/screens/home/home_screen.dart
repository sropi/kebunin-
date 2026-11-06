import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final productService = context.watch<ProductService>();
    final user = authService.currentUser;
    final popularProducts = productService.popularProducts;
    final recommendedProducts = productService.recommendedProducts;
    final categories = productService.categories;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      body: SafeArea(
        child: RefreshIndicator(
          color: KebuninColors.forestGreen,
          onRefresh: () => productService.fetchData(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
            // Top App Header
            SliverToBoxAdapter(
              child: Container(
                color: KebuninColors.white,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Column(
                  children: [
                    // Top User Bar: Location & Cart
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: KebuninColors.forestGreen,
                              width: 1.5,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                user?.avatarUrl ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Halo, ${user?.name ?? "Sahabat Tani"}!',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: KebuninColors.charcoal,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '👋',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 13,
                                    color: KebuninColors.forestGreen,
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      user?.address ?? 'Jakarta Barat',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: KebuninColors.mutedGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Quick Notification / Promo Icon
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.search);
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: KebuninColors.charcoal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Search Trigger Bar
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.search);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: KebuninColors.warmCream,
                          borderRadius: BorderRadius.circular(KebuninRadius.md),
                          border: Border.all(color: KebuninColors.border),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: KebuninColors.mutedGrey,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Cari bayam, wortel, brokoli segar...',
                              style: TextStyle(
                                fontSize: 13,
                                color: KebuninColors.mutedGrey,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.tune_rounded,
                              size: 18,
                              color: KebuninColors.forestGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Promotional Hero Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  height: 145,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(KebuninRadius.lg),
                    gradient: const LinearGradient(
                      colors: [KebuninColors.forestGreen, Color(0xFF2E6F48)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x16245C3A),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Decorative Pattern
                      Positioned(
                        right: -15,
                        bottom: -15,
                        child: Opacity(
                          opacity: 0.15,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: KebuninColors.carrotOrange,
                                borderRadius: BorderRadius.circular(
                                  KebuninRadius.pill,
                                ),
                              ),
                              child: const Text(
                                'PROMO PANEN SUBUH',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Diskon 20% Sayur Organik',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Gunakan kupon "SEGARHEMAT" saat checkout',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 11.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: 'Kategori Sayuran',
                    subtitle: 'Pilihan segar sesuai kebutuhan dapur',
                    onActionTap: () {
                      Navigator.pushNamed(context, AppRoutes.categories);
                    },
                  ),
                  SizedBox(
                    height: 98,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected =
                            productService.selectedCategoryId == cat.id;

                        return GestureDetector(
                          onTap: () {
                            productService.selectCategory(cat.id);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.categories,
                              arguments: cat.id,
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? KebuninColors.forestGreen
                                      : KebuninColors.white,
                                  borderRadius: BorderRadius.circular(
                                    KebuninRadius.lg,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? KebuninColors.forestGreen
                                        : KebuninColors.border,
                                    width: 1.5,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x06000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  cat.icon,
                                  size: 26,
                                  color: isSelected
                                      ? KebuninColors.white
                                      : KebuninColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 68,
                                child: Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? KebuninColors.forestGreen
                                        : KebuninColors.charcoal,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Popular Products Horizontal Rail
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  SectionHeader(
                    title: 'Paling Populer 🔥',
                    subtitle: 'Favorit ribuan keluarga nusantara',
                    onActionTap: () {
                      Navigator.pushNamed(context, AppRoutes.search);
                    },
                  ),
                  SizedBox(
                    height: 260,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: popularProducts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final product = popularProducts[index];
                        return SizedBox(
                          width: 165,
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.productDetail,
                                arguments: product,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Recommended Products Grid
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  SectionHeader(
                    title: 'Rekomendasi Hari Ini 🌱',
                    subtitle: 'Dipanen subuh tadi, jaminan kesegaran maksimal',
                    onActionTap: () {
                      Navigator.pushNamed(context, AppRoutes.search);
                    },
                  ),
                ],
              ),
            ),

            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.63,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = recommendedProducts[index];
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
                }, childCount: recommendedProducts.length),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
