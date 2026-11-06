import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService extends ChangeNotifier {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  final List<CartItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? _appliedPromoCode = "SEGARHEMAT";
  int _promoDiscount = 5000;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get appliedPromoCode => _appliedPromoCode;

  String? get _currentUserId {
    final client = _supabase;
    return client?.auth.currentUser?.id;
  }

  CartService() {
    fetchCart();
  }

  Future<void> fetchCart() async {
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
          .from('cart_items')
          .select('id, quantity, product_id, products(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      final list = (response as List<dynamic>).map((item) {
        final productMap = item['products'] as Map<String, dynamic>?;
        final product = productMap != null
            ? Product.fromMap(productMap)
            : Product(
                id: item['product_id']?.toString() ?? '',
                name: 'Sayur Segar',
                indonesianName: 'Sayur Segar',
                categoryId: '',
                price: 10000,
                unit: 'ikat',
                description: '',
                imageUrl:
                    'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
              );

        return CartItem(
          id: item['id']?.toString(),
          product: product,
          quantity: (item['quantity'] as num?)?.toInt() ?? 1,
          isSelected: true,
        );
      }).toList();

      _items.clear();
      _items.addAll(list);
    } catch (e) {
      debugPrint('Error fetching cart from Supabase: $e');
      _errorMessage = 'Gagal memuat keranjang.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get selectedItemCount => _items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.quantity);

  int get subtotal => _items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.subtotal);

  int get deliveryFee {
    if (subtotal == 0) return 0;
    return subtotal >= 75000 ? 0 : 10000;
  }

  int get discount {
    if (subtotal == 0) return 0;
    return _promoDiscount;
  }

  int get grandTotal {
    if (subtotal == 0) return 0;
    final total = subtotal + deliveryFee - discount;
    return total > 0 ? total : 0;
  }

  String get formattedSubtotal => _formatCurrency(subtotal);
  String get formattedDeliveryFee =>
      deliveryFee == 0 && subtotal > 0 ? 'GRATIS' : _formatCurrency(deliveryFee);
  String get formattedDiscount => _formatCurrency(discount);
  String get formattedGrandTotal => _formatCurrency(grandTotal);

  Future<void> addItem(Product product, {int quantity = 1}) async {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
      final item = _items[existingIndex];
      notifyListeners();
      _syncQuantityToSupabase(item);
    } else {
      final newItem = CartItem(product: product, quantity: quantity, isSelected: true);
      _items.add(newItem);
      notifyListeners();

      final client = _supabase;
      final userId = _currentUserId;
      if (userId != null && client != null) {
        try {
          final res = await client
              .from('cart_items')
              .insert({
                'user_id': userId,
                'product_id': product.id,
                'quantity': quantity,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              })
              .select('id')
              .maybeSingle();

          if (res != null && res['id'] != null) {
            final idx = _items.indexOf(newItem);
            if (idx >= 0) {
              _items[idx] = CartItem(
                id: res['id'].toString(),
                product: product,
                quantity: quantity,
                isSelected: true,
              );
            }
          }
        } catch (e) {
          debugPrint('Error inserting cart item to Supabase: $e');
        }
      }
    }
  }

  Future<void> _syncQuantityToSupabase(CartItem item) async {
    final client = _supabase;
    final userId = _currentUserId;
    if (userId == null || client == null) return;

    try {
      if (item.id != null) {
        await client.from('cart_items').update({
          'quantity': item.quantity,
          'updated_at': DateTime.now().toIso8601String(),
        }).eq('id', item.id!);
      } else {
        await client.from('cart_items').update({
          'quantity': item.quantity,
          'updated_at': DateTime.now().toIso8601String(),
        }).match({
          'user_id': userId,
          'product_id': item.product.id,
        });
      }
    } catch (e) {
      debugPrint('Error updating cart quantity in Supabase: $e');
    }
  }

  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity += 1;
      final item = _items[index];
      notifyListeners();
      _syncQuantityToSupabase(item);
    }
  }

  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
        final item = _items[index];
        notifyListeners();
        _syncQuantityToSupabase(item);
      } else {
        removeItem(productId);
      }
    }
  }

  void setQuantity(String productId, int qty) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (qty <= 0) {
        removeItem(productId);
      } else {
        _items[index].quantity = qty;
        final item = _items[index];
        notifyListeners();
        _syncQuantityToSupabase(item);
      }
    }
  }

  Future<void> removeItem(String productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final item = _items.removeAt(index);
    notifyListeners();

    final client = _supabase;
    final userId = _currentUserId;
    if (userId != null && client != null) {
      try {
        if (item.id != null) {
          await client.from('cart_items').delete().eq('id', item.id!);
        } else {
          await client.from('cart_items').delete().match({
            'user_id': userId,
            'product_id': productId,
          });
        }
      } catch (e) {
        debugPrint('Error deleting cart item in Supabase: $e');
      }
    }
  }

  void toggleSelect(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll(bool select) {
    for (var item in _items) {
      item.isSelected = select;
    }
    notifyListeners();
  }

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  int getQuantity(String productId) {
    final item = _items.cast<CartItem?>().firstWhere(
          (item) => item?.product.id == productId,
          orElse: () => null,
        );
    return item?.quantity ?? 0;
  }

  void applyPromo(String code) {
    if (code.toUpperCase() == "SEGARHEMAT") {
      _appliedPromoCode = "SEGARHEMAT";
      _promoDiscount = 5000;
    } else if (code.toUpperCase() == "PANENPAGI") {
      _appliedPromoCode = "PANENPAGI";
      _promoDiscount = 10000;
    }
    notifyListeners();
  }

  void removePromo() {
    _appliedPromoCode = null;
    _promoDiscount = 0;
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    notifyListeners();

    final client = _supabase;
    final userId = _currentUserId;
    if (userId != null && client != null) {
      try {
        await client.from('cart_items').delete().eq('user_id', userId);
      } catch (e) {
        debugPrint('Error clearing cart in Supabase: $e');
      }
    }
  }

  String _formatCurrency(int amount) {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(amount);
  }
}
