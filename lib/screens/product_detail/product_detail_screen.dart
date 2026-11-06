import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../models/product.dart';
import '../../services/cart_service.dart';
import '../../services/product_service.dart';
import '../../widgets/common_button.dart';
import '../../widgets/status_badge.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final cartService = context.watch<CartService>();
    final productService = context.watch<ProductService>();
    final isFav = productService.isFavorite(product.id);

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header with Back & Action buttons
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: KebuninColors.white,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: KebuninColors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: KebuninColors.charcoal),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: KebuninColors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: isFav ? KebuninColors.error : KebuninColors.charcoal,
                    ),
                    onPressed: () {
                      productService.toggleFavorite(product.id);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 12.0),
                child: CircleAvatar(
                  backgroundColor: KebuninColors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined,
                        size: 20, color: KebuninColors.charcoal),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan produk disalin ke papan klip.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFEBF5EE),
                      child: const Center(
                        child: Icon(Icons.eco_rounded,
                            size: 60, color: KebuninColors.leafGreen),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detail Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(KebuninRadius.xl),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Row(
                    children: [
                      if (product.isOrganic) ...[
                        StatusBadge.organic(),
                        const SizedBox(width: 8),
                      ],
                      if (product.isFreshHarvest) ...[
                        StatusBadge.fresh(),
                        const SizedBox(width: 8),
                      ],
                      if (product.hasDiscount)
                        StatusBadge.discount(product.discountPercent),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Product Name & Unit
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: KebuninColors.charcoal,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.indonesianName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: KebuninColors.forestGreen,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: KebuninColors.warmCream,
                      borderRadius: BorderRadius.circular(KebuninRadius.md),
                      border: Border.all(color: KebuninColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Harga Satuan',
                              style: TextStyle(
                                fontSize: 11,
                                color: KebuninColors.mutedGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  product.formattedPrice,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: KebuninColors.forestGreen,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.unit,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: KebuninColors.mutedGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (product.hasDiscount)
                              Text(
                                product.formattedOriginalPrice,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: KebuninColors.mutedGrey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        // Rating box
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 20, color: KebuninColors.carrotOrange),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: KebuninColors.charcoal,
                              ),
                            ),
                            Text(
                              ' (${product.reviewCount})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: KebuninColors.mutedGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Farm Origin Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F8F4),
                      borderRadius: BorderRadius.circular(KebuninRadius.md),
                      border: Border.all(
                          color: KebuninColors.leafGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: KebuninColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.agriculture_rounded,
                              size: 20, color: KebuninColors.forestGreen),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Asal Panen & Standar Higienis',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: KebuninColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.farmOrigin,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: KebuninColors.charcoal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF414941),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Freshness Guarantee Accordion / Info Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: KebuninColors.warmCream,
                      borderRadius: BorderRadius.circular(KebuninRadius.md),
                      border: Border.all(color: KebuninColors.border),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shield_outlined,
                                size: 18, color: KebuninColors.forestGreen),
                            SizedBox(width: 8),
                            Text(
                              'Garansi Sayur Segar 100%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: KebuninColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Jika sayur layu, busuk, atau cacat saat diterima, kami ganti baru gratis tanpa ribet.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: KebuninColors.mutedGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom sheet spacing
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: KebuninColors.white,
          border: Border(
            top: BorderSide(color: KebuninColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Quantity Stepper
              Container(
                decoration: BoxDecoration(
                  color: KebuninColors.warmCream,
                  borderRadius: BorderRadius.circular(KebuninRadius.md),
                  border: Border.all(color: KebuninColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 16),
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (_selectedQuantity > 1) {
                          setState(() => _selectedQuantity--);
                        }
                      },
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 28),
                      alignment: Alignment.center,
                      child: Text(
                        '$_selectedQuantity',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 16),
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() => _selectedQuantity++);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Add to Cart CTA
              Expanded(
                child: CommonButton(
                  text: 'Beli Sekarang',
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: () {
                    cartService.addItem(product, quantity: _selectedQuantity);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '$_selectedQuantity ${product.name} dimasukkan ke keranjang.'),
                        backgroundColor: KebuninColors.forestGreen,
                        action: SnackBarAction(
                          label: 'Lihat Keranjang',
                          textColor: KebuninColors.carrotOrange,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.cart);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
