import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../data/mock_data.dart';

class OrderService extends ChangeNotifier {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  List<Order> _orders = List.from(MockData.initialOrders);
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get _currentUserId {
    final client = _supabase;
    return client?.auth.currentUser?.id;
  }

  OrderService() {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final client = _supabase;
    final userId = _currentUserId;
    if (userId == null || client == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await client
          .from('orders')
          .select('''
            id, user_id, status, total_amount, delivery_fee, payment_status, address_id, created_at,
            addresses (id, user_id, recipient_name, phone, full_address, city, postal_code, is_default),
            order_items (id, order_id, product_id, quantity, price, subtotal, products (*)),
            payments (id, order_id, amount, payment_method, status, paid_at, created_at)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final list = (response as List<dynamic>)
          .map((item) => Order.fromSupabase(item as Map<String, dynamic>))
          .toList();

      if (list.isNotEmpty) {
        _orders = list;
      }
    } catch (e) {
      debugPrint('Error fetching orders from Supabase: $e');
      _errorMessage = 'Gagal memuat riwayat pesanan dari Supabase.';
      if (_orders.isEmpty) {
        _orders = List.from(MockData.initialOrders);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status == OrderStatus.menungguPembayaran ||
          o.status == OrderStatus.diproses ||
          o.status == OrderStatus.dikirim)
      .toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.selesai).toList();

  List<Order> getOrdersByStatus(OrderStatus? status) {
    if (status == null) return _orders;
    return _orders.where((o) => o.status == status).toList();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<Order> createOrder({
    required List<CartItem> cartItems,
    required int subtotal,
    required int shippingCost,
    required int discount,
    required String recipientName,
    required String recipientPhone,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final now = DateTime.now();
    final randomSuffix = Random().nextInt(9000) + 1000;
    final orderNumber =
        'KBN-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$randomSuffix';

    final client = _supabase;
    final userId = _currentUserId;

    // Create local Order representation immediately
    final orderItems = cartItems
        .map((ci) => OrderItem(
              product: ci.product,
              quantity: ci.quantity,
              price: ci.product.price,
            ))
        .toList();

    var newOrder = Order(
      id: 'ord_${now.millisecondsSinceEpoch}',
      orderNumber: orderNumber,
      createdAt: now,
      items: orderItems,
      subtotal: subtotal,
      shippingCost: shippingCost,
      discount: discount,
      status: OrderStatus.diproses,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      courierName: 'Kurir Dingin KEBUNIN Express',
      trackingNumber: 'KBN-EXP-$randomSuffix',
      trackingSteps: [
        TrackingStep(
          title: 'Pesanan Dikonfirmasi',
          description: 'Pembayaran via $paymentMethod berhasil.',
          time: now,
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Sayur Disiapkan di Hub Petani',
          description: 'Sayur dipetik higienis dan dikemas rapi.',
          time: now.add(const Duration(minutes: 5)),
          isCompleted: true,
          isCurrent: true,
        ),
        TrackingStep(
          title: 'Penjemputan Kurir Dingin KEBUNIN',
          description: 'Kurir menuju lokasi hub tani untuk pickup sayur.',
          time: now.add(const Duration(minutes: 30)),
          isCompleted: false,
        ),
        TrackingStep(
          title: 'Pesanan Sampai di Rumah',
          description: 'Sayur segar siap diterima di depan pintu Anda.',
          time: now.add(const Duration(hours: 1)),
          isCompleted: false,
        ),
      ],
    );

    // Save to Supabase if authenticated
    if (userId != null && client != null) {
      try {
        // 1. Get or create address in addresses table
        String? addressId;
        final existingAddr = await client
            .from('addresses')
            .select('id')
            .eq('user_id', userId)
            .limit(1)
            .maybeSingle();

        if (existingAddr != null) {
          addressId = existingAddr['id'].toString();
        } else {
          final newAddr = await client
              .from('addresses')
              .insert({
                'user_id': userId,
                'recipient_name': recipientName,
                'phone': recipientPhone,
                'full_address': shippingAddress,
                'city': 'Jakarta Barat',
                'postal_code': '11530',
                'is_default': true,
              })
              .select('id')
              .single();
          addressId = newAddr['id'].toString();
        }

        final calculatedTotal = subtotal + shippingCost - discount;

        // 2. Insert into orders table
        final orderRow = await client
            .from('orders')
            .insert({
              'user_id': userId,
              'status': 'diproses',
              'total_amount': calculatedTotal,
              'delivery_fee': shippingCost,
              'payment_status': 'paid',
              'address_id': addressId,
              'created_at': now.toIso8601String(),
            })
            .select('id')
            .single();

        final createdOrderId = orderRow['id'].toString();

        // 3. Insert order items
        final orderItemsData = cartItems.map((ci) {
          final itemPrice = ci.product.price;
          return {
            'order_id': createdOrderId,
            'product_id': ci.product.id,
            'quantity': ci.quantity,
            'price': itemPrice,
            'subtotal': itemPrice * ci.quantity,
            'created_at': now.toIso8601String(),
          };
        }).toList();

        await client.from('order_items').insert(orderItemsData);

        // 4. Insert payment
        await client.from('payments').insert({
          'order_id': createdOrderId,
          'amount': calculatedTotal,
          'payment_method': paymentMethod,
          'status': 'completed',
          'paid_at': now.toIso8601String(),
          'created_at': now.toIso8601String(),
        });

        // 5. Update local order ID to match Supabase order ID
        newOrder = Order(
          id: createdOrderId,
          orderNumber: orderNumber,
          createdAt: now,
          items: orderItems,
          subtotal: subtotal,
          shippingCost: shippingCost,
          discount: discount,
          status: OrderStatus.diproses,
          recipientName: recipientName,
          recipientPhone: recipientPhone,
          shippingAddress: shippingAddress,
          paymentMethod: paymentMethod,
          courierName: 'Kurir Dingin KEBUNIN Express',
          trackingNumber: 'KBN-EXP-$randomSuffix',
          trackingSteps: newOrder.trackingSteps,
        );
      } catch (e) {
        debugPrint('Error saving order to Supabase: $e');
      }
    }

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }

  Future<void> cancelOrder(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index >= 0) {
      final old = _orders[index];
      _orders[index] = Order(
        id: old.id,
        orderNumber: old.orderNumber,
        createdAt: old.createdAt,
        items: old.items,
        subtotal: old.subtotal,
        shippingCost: old.shippingCost,
        discount: old.discount,
        status: OrderStatus.dibatalkan,
        recipientName: old.recipientName,
        recipientPhone: old.recipientPhone,
        shippingAddress: old.shippingAddress,
        paymentMethod: old.paymentMethod,
        courierName: old.courierName,
        trackingNumber: old.trackingNumber,
        trackingSteps: [
          ...old.trackingSteps,
          TrackingStep(
            title: 'Pesanan Dibatalkan',
            description: 'Pesanan telah dibatalkan oleh pelanggan.',
            time: DateTime.now(),
            isCompleted: true,
            isCurrent: true,
          )
        ],
      );
      notifyListeners();

      final client = _supabase;
      if (client != null) {
        try {
          await client
              .from('orders')
              .update({'status': 'dibatalkan'}).eq('id', orderId);
        } catch (e) {
          debugPrint('Error cancelling order in Supabase: $e');
        }
      }
    }
  }
}
