import 'package:intl/intl.dart';
import 'product.dart';

class CartItem {
  final String? id;
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    this.id,
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  int get subtotal => product.price * quantity;

  String get formattedSubtotal {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(subtotal);
  }
}
