import 'package:flutter/material.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../models/order.dart';
import '../../widgets/common_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Celebratory Circle Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5EE),
                  shape: BoxShape.circle,
                  border: Border.all(color: KebuninColors.leafGreen, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x16245C3A),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 60,
                    color: KebuninColors.forestGreen,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Pesanan Berhasil Dibuat!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: KebuninColors.forestGreen,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              const Text(
                'Terima kasih! Petani mitra KEBUNIN sedang menyiapkan panen sayur terbaik untuk Anda.',
                style: TextStyle(
                  fontSize: 13,
                  color: KebuninColors.mutedGrey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Order Summary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: KebuninColors.white,
                  borderRadius: BorderRadius.circular(KebuninRadius.lg),
                  border: Border.all(color: KebuninColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRow('Nomor Pesanan', order.orderNumber, isBold: true),
                    const Divider(height: 18),
                    _buildRow('Jumlah Sayur', '${order.totalItemCount} item'),
                    const SizedBox(height: 6),
                    _buildRow('Total Pembayaran', order.formattedTotal,
                        isHighlight: true),
                    const SizedBox(height: 6),
                    _buildRow('Metode Pembayaran', order.paymentMethod),
                    const Divider(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.local_shipping_outlined,
                            size: 16, color: KebuninColors.forestGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Alamat: ${order.shippingAddress}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: KebuninColors.mutedGrey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              CommonButton(
                text: 'Pantau Pengiriman Sayur',
                icon: Icons.track_changes_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.orderDetail,
                    arguments: order,
                  );
                },
              ),

              const SizedBox(height: 12),

              CommonButton(
                text: 'Kembali Belanja',
                isOutlined: true,
                icon: Icons.storefront_outlined,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.mainNav,
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {bool isBold = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            color: KebuninColors.mutedGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 14 : 12.5,
            fontWeight: isBold || isHighlight ? FontWeight.w800 : FontWeight.w600,
            color: isHighlight
                ? KebuninColors.forestGreen
                : KebuninColors.charcoal,
          ),
        ),
      ],
    );
  }
}

