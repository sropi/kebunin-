import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'product.dart';

enum OrderStatus {
  menungguPembayaran,
  diproses,
  dikirim,
  selesai,
  dibatalkan,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return 'Menunggu Pembayaran';
      case OrderStatus.diproses:
        return 'Sedang Diproses';
      case OrderStatus.dikirim:
        return 'Dalam Pengiriman';
      case OrderStatus.selesai:
        return 'Pesanan Selesai';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String get dbValue {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return 'menunggu_pembayaran';
      case OrderStatus.diproses:
        return 'diproses';
      case OrderStatus.dikirim:
        return 'dikirim';
      case OrderStatus.selesai:
        return 'selesai';
      case OrderStatus.dibatalkan:
        return 'dibatalkan';
    }
  }

  static OrderStatus fromString(String? status) {
    final s = status?.toLowerCase().trim() ?? '';
    if (s.contains('bayar') || s.contains('pending')) {
      return OrderStatus.menungguPembayaran;
    } else if (s.contains('proses') || s.contains('process')) {
      return OrderStatus.diproses;
    } else if (s.contains('kirim') || s.contains('ship') || s.contains('deliver')) {
      return OrderStatus.dikirim;
    } else if (s.contains('selesai') || s.contains('complete') || s.contains('success')) {
      return OrderStatus.selesai;
    } else if (s.contains('batal') || s.contains('cancel')) {
      return OrderStatus.dibatalkan;
    }
    return OrderStatus.diproses;
  }

  Color get color {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return const Color(0xFFE99A45); // Orange
      case OrderStatus.diproses:
        return const Color(0xFF3B82F6); // Blue
      case OrderStatus.dikirim:
        return const Color(0xFF78A85A); // Leaf green
      case OrderStatus.selesai:
        return const Color(0xFF245C3A); // Forest green
      case OrderStatus.dibatalkan:
        return const Color(0xFFBA1A1A); // Red
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return const Color(0xFFFFF7ED);
      case OrderStatus.diproses:
        return const Color(0xFFEFF6FF);
      case OrderStatus.dikirim:
        return const Color(0xFFF0FDF4);
      case OrderStatus.selesai:
        return const Color(0xFFEBF5EE);
      case OrderStatus.dibatalkan:
        return const Color(0xFFFEF2F2);
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.menungguPembayaran:
        return Icons.payment;
      case OrderStatus.diproses:
        return Icons.soup_kitchen_outlined;
      case OrderStatus.dikirim:
        return Icons.local_shipping_outlined;
      case OrderStatus.selesai:
        return Icons.check_circle_outline;
      case OrderStatus.dibatalkan:
        return Icons.cancel_outlined;
    }
  }
}

class TrackingStep {
  final String title;
  final String description;
  final DateTime time;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class OrderItem {
  final Product product;
  final int quantity;
  final int price;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  int get subtotal => price * quantity;

  String get formattedSubtotal {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(subtotal);
  }

  factory OrderItem.fromSupabase(Map<String, dynamic> map, {Product? productFallback}) {
    final rawProduct = map['products'] as Map<String, dynamic>?;
    final product = rawProduct != null
        ? Product.fromMap(rawProduct)
        : productFallback ??
            Product(
              id: map['product_id']?.toString() ?? '',
              name: 'Sayur Segar',
              indonesianName: 'Sayur Segar',
              categoryId: '',
              price: (map['price'] as num?)?.toInt() ?? 0,
              unit: 'ikat',
              description: '',
              imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
            );

    final rawPrice = map['price'];
    final price = rawPrice is num
        ? rawPrice.toInt()
        : int.tryParse(rawPrice?.toString() ?? '0') ?? product.price;

    final rawQty = map['quantity'];
    final quantity = rawQty is num
        ? rawQty.toInt()
        : int.tryParse(rawQty?.toString() ?? '1') ?? 1;

    return OrderItem(
      product: product,
      quantity: quantity,
      price: price,
    );
  }
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime createdAt;
  final List<OrderItem> items;
  final int subtotal;
  final int shippingCost;
  final int discount;
  final OrderStatus status;
  final String recipientName;
  final String recipientPhone;
  final String shippingAddress;
  final String paymentMethod;
  final String courierName;
  final String trackingNumber;
  final List<TrackingStep> trackingSteps;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    this.discount = 0,
    required this.status,
    required this.recipientName,
    required this.recipientPhone,
    required this.shippingAddress,
    required this.paymentMethod,
    this.courierName = "Kurir Dingin KEBUNIN Express",
    this.trackingNumber = "KBN-EXP-889214",
    this.trackingSteps = const [],
  });

  factory Order.fromSupabase(Map<String, dynamic> map) {
    final id = map['id']?.toString() ?? '';
    final createdAt = DateTime.tryParse(map['created_at']?.toString() ?? '') ?? DateTime.now();

    final statusStr = map['status']?.toString();
    final status = OrderStatusExtension.fromString(statusStr);

    final rawTotal = map['total_amount'];
    final totalAmount = rawTotal is num ? rawTotal.toInt() : int.tryParse(rawTotal?.toString() ?? '0') ?? 0;

    final rawDelivery = map['delivery_fee'];
    final deliveryFee = rawDelivery is num ? rawDelivery.toInt() : int.tryParse(rawDelivery?.toString() ?? '10000') ?? 10000;

    final subtotal = (totalAmount - deliveryFee) > 0 ? (totalAmount - deliveryFee) : totalAmount;

    // Address
    final addressMap = map['addresses'] as Map<String, dynamic>?;
    final recipientName = addressMap?['recipient_name']?.toString() ?? 'Sahabat KEBUNIN';
    final recipientPhone = addressMap?['phone']?.toString() ?? '0812-3456-7890';
    final fullAddr = addressMap?['full_address']?.toString() ?? '';
    final city = addressMap?['city']?.toString() ?? '';
    final shippingAddress = fullAddr.isNotEmpty
        ? (city.isNotEmpty ? '$fullAddr, $city' : fullAddr)
        : 'Jl. Kebon Jeruk Indah No. 12, Jakarta Barat';

    // Payment
    final paymentsList = map['payments'] as List<dynamic>?;
    final paymentMap = paymentsList != null && paymentsList.isNotEmpty
        ? paymentsList.first as Map<String, dynamic>
        : null;
    final paymentMethod = paymentMap?['payment_method']?.toString() ?? 'QRIS (GoPay/OVO/ShopeePay)';

    // Items
    final rawItems = map['order_items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((item) => OrderItem.fromSupabase(item as Map<String, dynamic>))
        .toList();

    final shortId = id.length >= 6 ? id.substring(0, 6).toUpperCase() : id.toUpperCase();
    final orderNumber = 'KBN-${createdAt.year}${createdAt.month.toString().padLeft(2, '0')}${createdAt.day.toString().padLeft(2, '0')}-$shortId';

    // Build tracking steps
    final steps = [
      TrackingStep(
        title: 'Pesanan Dikonfirmasi',
        description: 'Pembayaran via $paymentMethod berhasil diverifikasi.',
        time: createdAt,
        isCompleted: true,
      ),
      TrackingStep(
        title: 'Sayur Disiapkan di Hub Petani',
        description: 'Sayur dipetik higienis dan dikemas rapi dengan ice gel.',
        time: createdAt.add(const Duration(minutes: 5)),
        isCompleted: status != OrderStatus.menungguPembayaran && status != OrderStatus.dibatalkan,
        isCurrent: status == OrderStatus.diproses,
      ),
      TrackingStep(
        title: 'Penjemputan Kurir Dingin KEBUNIN',
        description: 'Kurir menuju lokasi hub tani untuk pickup sayur.',
        time: createdAt.add(const Duration(minutes: 30)),
        isCompleted: status == OrderStatus.dikirim || status == OrderStatus.selesai,
        isCurrent: status == OrderStatus.dikirim,
      ),
      TrackingStep(
        title: 'Pesanan Sampai di Rumah',
        description: 'Sayur segar diterima di depan pintu Anda.',
        time: createdAt.add(const Duration(hours: 1)),
        isCompleted: status == OrderStatus.selesai,
        isCurrent: status == OrderStatus.selesai,
      ),
    ];

    return Order(
      id: id,
      orderNumber: orderNumber,
      createdAt: createdAt,
      items: items,
      subtotal: subtotal,
      shippingCost: deliveryFee,
      discount: 0,
      status: status,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      courierName: 'Kurir Dingin KEBUNIN Express',
      trackingNumber: 'KBN-EXP-$shortId',
      trackingSteps: steps,
    );
  }

  int get totalAmount => subtotal + shippingCost - discount;

  String get formattedTotal {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(totalAmount);
  }

  String get formattedCreatedAt {
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    return formatter.format(createdAt);
  }

  int get totalItemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
