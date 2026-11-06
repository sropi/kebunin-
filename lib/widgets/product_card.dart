import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/constants.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'status_badge.dart';
import 'quantity_stepper.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final quantity = cartService.getQuantity(product.id);

    return Container(
      decoration: BoxDecoration(
        color: KebuninColors.white,
        borderRadius: BorderRadius.circular(KebuninRadius.md),
        border: Border.all(color: KebuninColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08292D29),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(KebuninRadius.md),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.25,
                      child: Container(
                        color: KebuninColors.warmCream,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFEBF5EE),
                            child: const Center(
                              child: Icon(
                                Icons.eco_rounded,
                                size: 40,
                                color: KebuninColors.leafGreen,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: KebuninColors.warmCream,
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                        KebuninColors.leafGreen),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Top Left: Organic or Fresh Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: product.isOrganic
                        ? StatusBadge.organic(fontSize: 9.5)
                        : StatusBadge.fresh(fontSize: 9.5),
                  ),

                  // Top Right: Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: StatusBadge.discount(product.discountPercent,
                          fontSize: 9.5),
                    ),
                ],
              ),

              // Product Info & Price
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.charcoal,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product.unit,
                      style: const TextStyle(
                        fontSize: 11,
                        color: KebuninColors.mutedGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price & Action Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.hasDiscount) ...[
                                Text(
                                  product.formattedOriginalPrice,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: KebuninColors.mutedGrey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                              Text(
                                product.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: KebuninColors.forestGreen,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quick Add or Quantity Stepper
                        if (quantity == 0)
                          InkWell(
                            onTap: () {
                              cartService.addItem(product, quantity: 1);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product.name} ditambahkan ke keranjang.'),
                                  backgroundColor: KebuninColors.forestGreen,
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                            borderRadius:
                                BorderRadius.circular(KebuninRadius.pill),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: KebuninColors.forestGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 18,
                                color: KebuninColors.white,
                              ),
                            ),
                          )
                        else
                          QuantityStepper(
                            quantity: quantity,
                            size: 28,
                            onIncrement: () =>
                                cartService.incrementQuantity(product.id),
                            onDecrement: () =>
                                cartService.decrementQuantity(product.id),
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
    );
  }
}
