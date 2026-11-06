import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final int productCount;
  final Color? color;
  final String? imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.productCount = 0,
    this.color,
    this.imageUrl,
  });

  factory Category.fromMap(Map<String, dynamic> map, {int productCount = 0}) {
    final name = (map['name'] as String?)?.trim() ?? '';
    final description = (map['description'] as String?) ?? '';
    final imageUrl = map['image_url'] as String?;

    return Category(
      id: map['id']?.toString() ?? '',
      name: name,
      icon: _iconForCategory(name),
      description: description,
      productCount: productCount,
      imageUrl: imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('daun')) {
      return Icons.eco_outlined;
    } else if (lower.contains('buah')) {
      return Icons.local_florist_outlined;
    } else if (lower.contains('umbi')) {
      return Icons.agriculture_outlined;
    } else if (lower.contains('bunga')) {
      return Icons.spa_outlined;
    } else if (lower.contains('bumbu') || lower.contains('cabai')) {
      return Icons.whatshot_outlined;
    } else if (lower.contains('paket')) {
      return Icons.kitchen_outlined;
    } else if (lower.contains('semua')) {
      return Icons.grid_view_rounded;
    }
    return Icons.grass_outlined;
  }
}
