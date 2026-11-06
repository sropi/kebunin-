import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../widgets/common_button.dart';
import '../../widgets/custom_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = 'QRIS / GoPay Instant';
  String _deliverySlot = 'Pengiriman Subuh (06:00 - 08:00 WIB)';
  final _promoController = TextEditingController(text: 'SEGARHEMAT');
  bool _isProcessing = false;

  final List<String> _paymentMethods = [
    'QRIS / GoPay Instant',
    'BCA Virtual Account',
    'Mandiri Virtual Account',
    'Bayar di Tempat (COD)',
  ];

  final List<String> _deliverySlots = [
    'Pengiriman Subuh (06:00 - 08:00 WIB)',
    'Pengiriman Pagi (09:00 - 11:00 WIB)',
    'Pengiriman Sore (15:00 - 17:00 WIB)',
  ];

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() async {
    final cartService = context.read<CartService>();
    final authService = context.read<AuthService>();
    final orderService = context.read<OrderService>();
    final user = authService.currentUser;

    if (cartService.selectedItemCount == 0) return;

    setState(() => _isProcessing = true);

    final createdOrder = await orderService.createOrder(
      cartItems:
          cartService.items.where((item) => item.isSelected).toList(),
      subtotal: cartService.subtotal,
      shippingCost: cartService.deliveryFee,
      discount: cartService.discount,
      recipientName: user?.name ?? 'Sahabat KEBUNIN',
      recipientPhone: user?.phone ?? '0812-3456-7890',
      shippingAddress:
          '${user?.address ?? "Jl. Kebon Jeruk No. 12"}, ${user?.city ?? "Jakarta Barat"} ${user?.postalCode ?? "11530"}',
      paymentMethod: _selectedPayment,
    );

    // Clear cart items that were checked out
    await cartService.clear();

    if (!mounted) return;
    setState(() => _isProcessing = false);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.orderSuccess,
      arguments: createdOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final selectedItems =
        cartService.items.where((i) => i.isSelected).toList();

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: const CustomAppBar(
        title: 'Checkout Pembayaran',
        showCartButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 18, color: KebuninColors.forestGreen),
                          SizedBox(width: 6),
                          Text(
                            'Alamat Pengiriman',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: KebuninColors.charcoal,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.editProfile);
                        },
                        child: const Text(
                          'Ubah',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: KebuninColors.forestGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    '${user?.name ?? "Budi Santoso"} • ${user?.phone ?? "0812-3456-7890"}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${user?.address ?? "Jl. Kebon Jeruk Indah No. 12"}, ${user?.city ?? "Jakarta Barat"} ${user?.postalCode ?? "11530"}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: KebuninColors.mutedGrey,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Delivery Time Slot Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 18, color: KebuninColors.forestGreen),
                      SizedBox(width: 6),
                      Text(
                        'Pilihan Jam Tiba Sayur',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._deliverySlots.map((slot) {
                    final isSelected = _deliverySlot == slot;
                    return InkWell(
                      onTap: () => setState(() => _deliverySlot = slot),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: slot,
                              groupValue: _deliverySlot,
                              activeColor: KebuninColors.forestGreen,
                              onChanged: (val) =>
                                  setState(() => _deliverySlot = val!),
                            ),
                            Expanded(
                              child: Text(
                                slot,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: KebuninColors.charcoal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order Items Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ringkasan Sayur',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                      Text(
                        '${selectedItems.length} jenis sayur',
                        style: const TextStyle(
                          fontSize: 12,
                          color: KebuninColors.mutedGrey,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  ...selectedItems.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(KebuninRadius.sm),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: KebuninColors.charcoal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${item.quantity}x ${item.product.formattedPrice}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: KebuninColors.mutedGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              item.formattedSubtotal,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: KebuninColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Payment Method Selector Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.payment_rounded,
                          size: 18, color: KebuninColors.forestGreen),
                      SizedBox(width: 6),
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ..._paymentMethods.map((method) {
                    final isSelected = _selectedPayment == method;
                    return InkWell(
                      onTap: () => setState(() => _selectedPayment = method),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: method,
                              groupValue: _selectedPayment,
                              activeColor: KebuninColors.forestGreen,
                              onChanged: (val) =>
                                  setState(() => _selectedPayment = val!),
                            ),
                            Text(
                              method,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: KebuninColors.charcoal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Promo Code Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined,
                      size: 20, color: KebuninColors.carrotOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kupon Sayur Aktif',
                          style: TextStyle(
                              fontSize: 11, color: KebuninColors.mutedGrey),
                        ),
                        Text(
                          cartService.appliedPromoCode ?? "Tidak ada kupon",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: KebuninColors.carrotOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Hemat Rp5.000',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.carrotOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Bottom Payment Bar
      bottomNavigationBar: Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(
                      fontSize: 11,
                      color: KebuninColors.mutedGrey,
                    ),
                  ),
                  Text(
                    cartService.formattedGrandTotal,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: KebuninColors.forestGreen,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 175,
                child: CommonButton(
                  text: 'Buat Pesanan',
                  icon: Icons.check_circle_rounded,
                  isLoading: _isProcessing,
                  onPressed: _handlePlaceOrder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

