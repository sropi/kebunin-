import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../data/mock_data.dart';

class ProductService extends ChangeNotifier {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  List<Product> _products = [];
  List<Category> _categories = List.from(MockData.categories);
  String _selectedCategoryId = 'cat_all';
  String _searchQuery = '';
  final Set<String> _favoriteProductIds = {};

  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get allProducts => _products;
  List<Category> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Product> get popularProducts => _products.take(4).toList();

  List<Product> get recommendedProducts => _products.toList();

  List<Product> get filteredProducts {
    return _products.where((product) {
      final matchesCategory = _selectedCategoryId == 'cat_all' ||
          product.categoryId == _selectedCategoryId;

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.indonesianName.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  ProductService() {
    fetchData();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.wait([
      fetchCategories(),
      fetchProducts(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    final client = _supabase;
    if (client == null) {
      if (_categories.isEmpty) {
        _categories = List.from(MockData.categories);
      }
      return;
    }

    try {
      final res = await client
          .from('categories')
          .select()
          .order('name', ascending: true);

      final list = (res as List<dynamic>)
          .map((item) => Category.fromMap(item as Map<String, dynamic>))
          .toList();

      if (list.isNotEmpty) {
        const allCategory = Category(
          id: 'cat_all',
          name: 'Semua',
          icon: Icons.grid_view_rounded,
          description: 'Semua sayur & hasil tani',
        );
        _categories = [allCategory, ...list];
      }
    } catch (e) {
      debugPrint('Error fetching categories in ProductService: $e');
      if (_categories.isEmpty) {
        _categories = List.from(MockData.categories);
      }
    }
  }

  Future<void> fetchProducts() async {
    final client = _supabase;
    if (client == null) {
      _products = List.from(MockData.products);
      return;
    }

    try {
      final res = await client
          .from('products')
          .select()
          .order('name', ascending: true);

      final list = (res as List<dynamic>)
          .map((item) => Product.fromMap(item as Map<String, dynamic>))
          .toList();

      if (list.isNotEmpty) {
        _products = list;
        if (_products.isNotEmpty && _favoriteProductIds.isEmpty) {
          _favoriteProductIds.add(_products.first.id);
        }
      } else {
        _products = List.from(MockData.products);
      }
    } catch (e) {
      debugPrint('Error fetching products from Supabase: $e');
      _errorMessage = 'Gagal memuat daftar sayur dari database Supabase.';
      _products = List.from(MockData.products);
    }
  }

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isFavorite(String productId) => _favoriteProductIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }
}
