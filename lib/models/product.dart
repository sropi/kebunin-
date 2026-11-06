import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final String indonesianName;
  final String categoryId;
  final int price;
  final int? originalPrice;
  final String unit;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final bool isFreshHarvest;
  final bool isPopular;
  final bool isRecommended;
  final int stock;
  final String farmOrigin;

  const Product({
    required this.id,
    required this.name,
    required this.indonesianName,
    required this.categoryId,
    required this.price,
    this.originalPrice,
    required this.unit,
    required this.description,
    required this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 120,
    this.isOrganic = true,
    this.isFreshHarvest = true,
    this.isPopular = false,
    this.isRecommended = false,
    this.stock = 50,
    this.farmOrigin = "Kelompok Tani Lembang, Jawa Barat",
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    final name = (map['name'] as String?)?.trim() ?? 'Produk Sayur';
    final rawPrice = map['price'];
    final price = rawPrice is num
        ? rawPrice.toInt()
        : int.tryParse(rawPrice?.toString() ?? '0') ?? 0;

    final rawStock = map['stock'];
    final stock = rawStock is num
        ? rawStock.toInt()
        : int.tryParse(rawStock?.toString() ?? '50') ?? 50;

    final rawImageUrl = map['image_url'] as String?;
    final imageUrl = (rawImageUrl != null && rawImageUrl.trim().isNotEmpty)
        ? rawImageUrl.trim()
        : _fallbackImageFor(name);

    return Product(
      id: map['id']?.toString() ?? '',
      name: name,
      indonesianName: name,
      categoryId: map['category_id']?.toString() ?? '',
      price: price,
      originalPrice: (price * 1.2).round(),
      unit: (map['unit'] as String?)?.trim() ?? 'ikat',
      description: (map['description'] as String?)?.trim() ??
          'Sayuran segar pilihan dipetik langsung dari kebun mitra tani lokal dengan standar kualitas terbaik.',
      imageUrl: imageUrl,
      stock: stock,
      rating: 4.8,
      reviewCount: 95,
      isOrganic: true,
      isFreshHarvest: true,
      isPopular: true,
      isRecommended: true,
      farmOrigin: 'Kelompok Tani Mitra KEBUNIN, Jawa Barat',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'price': price,
      'stock': stock,
      'unit': unit,
      'description': description,
      'image_url': imageUrl,
      'is_available': stock > 0,
    };
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  String get formattedPrice {
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(price);
  }

  String get formattedOriginalPrice {
    if (originalPrice == null) return '';
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currency.format(originalPrice);
  }

  static String _fallbackImageFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('bayam')) {
      return 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('wortel')) {
      return 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('tomat')) {
      return 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('brokoli')) {
      return 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('kentang')) {
      return 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('kangkung')) {
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('cabai') || lower.contains('cabe')) {
      return 'https://images.unsplash.com/photo-1563865436874-9aef32095fad?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('bawang')) {
      return 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('jagung')) {
      return 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('terong')) {
      return 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?auto=format&fit=crop&w=600&q=80';
    } else if (lower.contains('sawi') || lower.contains('pakcoy')) {
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80';
    }
    return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80';
  }
}
