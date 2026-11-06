import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import '../../widgets/custom_app_bar.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderService = context.watch<OrderService>();
    final currentOrder = orderService.getOrderById(order.id) ?? order;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: CustomAppBar(
        title: 'Detail Pengiriman',
        showCartButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: currentOrder.status.backgroundColor,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(
                    color: currentOrder.status.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(currentOrder.status.icon,
                      size: 28, color: currentOrder.status.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentOrder.status.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: currentOrder.status.color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'No. Pesanan: ${currentOrder.orderNumber}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: KebuninColors.charcoal.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Tracking Timeline Card
            Container(
              padding: const EdgeInsets.all(18),
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
                      Icon(Icons.timeline_rounded,
                          size: 18, color: KebuninColors.forestGreen),
                      SizedBox(width: 6),
                      Text(
                        'Pelacakan Pengiriman Panen',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (currentOrder.trackingSteps.isNotEmpty)
                    ...List.generate(currentOrder.trackingSteps.length, (index) {
                      final step = currentOrder.trackingSteps[index];
                      final isLast =
                          index == currentOrder.trackingSteps.length - 1;
                      return _buildTimelineStep(step, isLast);
                    })
                  else
                    const Text(
                      'Informasi pelacakan belum tersedia.',
                      style: TextStyle(
                          fontSize: 12, color: KebuninColors.mutedGrey),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Courier Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: KebuninColors.white,
                borderRadius: BorderRadius.circular(KebuninRadius.md),
                border: Border.all(color: KebuninColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: KebuninColors.warmCream,
                      borderRadius: BorderRadius.circular(KebuninRadius.sm),
                    ),
                    child: const Icon(Icons.delivery_dining_rounded,
                        size: 24, color: KebuninColors.forestGreen),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentOrder.courierName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: KebuninColors.charcoal,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Resi: ${currentOrder.trackingNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: KebuninColors.mutedGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded,
                        size: 18, color: KebuninColors.forestGreen),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nomor resi disalin ke papan klip.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Item Details List Card
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
                  const Text(
                    'Daftar Sayur yang Dipesan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const Divider(height: 20),
                  ...currentOrder.items.map((item) => Padding(
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
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: KebuninColors.charcoal,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity} x ${item.product.formattedPrice}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
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
                  const Text(
                    'Alamat Penerima',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const Divider(height: 18),
                  Text(
                    '${currentOrder.recipientName} • ${currentOrder.recipientPhone}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    currentOrder.shippingAddress,
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

            // Cost Summary Card
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
                  const Text(
                    'Rincian Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: KebuninColors.charcoal,
                    ),
                  ),
                  const Divider(height: 18),
                  _buildPriceRow('Metode Pembayaran', currentOrder.paymentMethod),
                  const SizedBox(height: 6),
                  _buildPriceRow('Waktu Pesanan', currentOrder.formattedCreatedAt),
                  const SizedBox(height: 6),
                  _buildPriceRow(
                    'Subtotal Produk',
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(currentOrder.subtotal),
                  ),
                  const SizedBox(height: 6),
                  _buildPriceRow(
                    'Biaya Pengiriman Dingin',
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(currentOrder.shippingCost),
                  ),
                  if (currentOrder.discount > 0) ...[
                    const SizedBox(height: 6),
                    _buildPriceRow(
                      'Diskon Kupon',
                      '-${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(currentOrder.discount)}',
                      isDiscount: true,
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Akhir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: KebuninColors.charcoal,
                        ),
                      ),
                      Text(
                        currentOrder.formattedTotal,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: KebuninColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Cancel button if still processing
            if (currentOrder.status == OrderStatus.diproses)
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Batalkan Pesanan Ini?'),
                        content: const Text(
                            'Sayur yang sedang disiapkan akan dibatalkan.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Kembali'),
                          ),
                          TextButton(
                            onPressed: () {
                              orderService.cancelOrder(currentOrder.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Batalkan',
                                style: TextStyle(color: KebuninColors.error)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.cancel_outlined,
                      size: 16, color: KebuninColors.error),
                  label: const Text(
                    'Batalkan Pesanan Ini',
                    style: TextStyle(
                      color: KebuninColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(TrackingStep step, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: step.isCompleted
                    ? KebuninColors.forestGreen
                    : const Color(0xFFE8ECE6),
                border: Border.all(
                  color: step.isCurrent
                      ? KebuninColors.carrotOrange
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                step.isCompleted ? Icons.check : Icons.circle,
                size: 12,
                color: step.isCompleted ? Colors.white : KebuninColors.mutedGrey,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: step.isCompleted
                    ? KebuninColors.forestGreen
                    : KebuninColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: step.isCurrent
                      ? KebuninColors.forestGreen
                      : KebuninColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                step.description,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: KebuninColors.mutedGrey,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: KebuninColors.mutedGrey),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDiscount ? KebuninColors.carrotOrange : KebuninColors.charcoal,
          ),
        ),
      ],
    );
  }
}

