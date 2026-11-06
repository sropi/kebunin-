import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/cart_service.dart';
import '../../widgets/common_button.dart';
import '../../widgets/quantity_stepper.dart';

class CartScreen extends StatelessWidget {
  final bool isRootTab;

  const CartScreen({super.key, this.isRootTab = false});

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final items = cartService.items;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: AppBar(
        backgroundColor: KebuninColors.white,
        elevation: 0,
        leading: !isRootTab && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: KebuninColors.charcoal),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: KebuninColors.charcoal,
          ),
        ),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Kosongkan Keranjang?'),
                    content: const Text(
                        'Semua sayur di dalam keranjang belanja akan dihapus.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          cartService.clear();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Kosongkan',
                            style: TextStyle(color: KebuninColors.error)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Hapus Semua',
                style: TextStyle(
                  fontSize: 12,
                  color: KebuninColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: KebuninColors.border, height: 1),
        ),
      ),
      body: items.isEmpty
          ? RefreshIndicator(
              color: KebuninColors.forestGreen,
              onRefresh: () => cartService.fetchCart(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildEmptyState(context),
                ),
              ),
            )
          : Column(
              children: [
                // Select All & Item Count Bar
                Container(
                  color: KebuninColors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: cartService.isAllSelected,
                            activeColor: KebuninColors.forestGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) {
                              cartService.selectAll(val ?? false);
                            },
                          ),
                          const Text(
                            'Pilih Semua Sayur',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: KebuninColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${cartService.selectedItemCount} dipilih',
                        style: const TextStyle(
                          fontSize: 12,
                          color: KebuninColors.mutedGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Item List
                Expanded(
                  child: RefreshIndicator(
                    color: KebuninColors.forestGreen,
                    onRefresh: () => cartService.fetchCart(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      final product = cartItem.product;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: KebuninColors.white,
                          borderRadius: BorderRadius.circular(KebuninRadius.md),
                          border: Border.all(color: KebuninColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Select Checkbox
                            Checkbox(
                              value: cartItem.isSelected,
                              activeColor: KebuninColors.forestGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (val) {
                                cartService.toggleSelect(product.id);
                              },
                            ),

                            // Product Thumbnail Image
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(KebuninRadius.sm),
                              child: Image.network(
                                product.imageUrl,
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 68,
                                  height: 68,
                                  color: KebuninColors.warmCream,
                                  child: const Icon(Icons.eco_rounded,
                                      color: KebuninColors.leafGreen),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info & Price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: KebuninColors.charcoal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    product.unit,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: KebuninColors.mutedGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.formattedPrice,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: KebuninColors.forestGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Stepper & Delete
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 18, color: KebuninColors.mutedGrey),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    cartService.removeItem(product.id);
                                  },
                                ),
                                const SizedBox(height: 8),
                                QuantityStepper(
                                  quantity: cartItem.quantity,
                                  size: 26,
                                  onIncrement: () => cartService
                                      .incrementQuantity(product.id),
                                  onDecrement: () => cartService
                                      .decrementQuantity(product.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

                // Order Price Calculation Summary
                Container(
                  padding: const EdgeInsets.all(16),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtotal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Subtotal Produk',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: KebuninColors.mutedGrey,
                              ),
                            ),
                            Text(
                              cartService.formattedSubtotal,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: KebuninColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Delivery cost
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ongkos Kirim Dingin',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: KebuninColors.mutedGrey,
                              ),
                            ),
                            Text(
                              cartService.formattedDeliveryFee,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: cartService.deliveryFee == 0
                                    ? KebuninColors.forestGreen
                                    : KebuninColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Promo discount
                        if (cartService.discount > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.discount_outlined,
                                      size: 14,
                                      color: KebuninColors.carrotOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Promo (${cartService.appliedPromoCode})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: KebuninColors.carrotOrange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '-${cartService.formattedDiscount}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: KebuninColors.carrotOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],

                        const Divider(height: 16),

                        // Grand Total & Checkout CTA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Pembayaran',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: KebuninColors.mutedGrey,
                                  ),
                                ),
                                Text(
                                  cartService.formattedGrandTotal,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: KebuninColors.forestGreen,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 170,
                              child: CommonButton(
                                text: 'Lanjut Checkout',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: cartService.selectedItemCount == 0
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.checkout);
                                      },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: KebuninColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KebuninColors.border),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 46,
                color: KebuninColors.mutedGrey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keranjang Belanja Masih Kosong',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: KebuninColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ayo pilih sayur segar hasil panen subuh hari ini untuk hidangan sehat keluarga.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: KebuninColors.mutedGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: CommonButton(
                text: 'Belanja Sayur',
                icon: Icons.storefront_outlined,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.mainNav);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
