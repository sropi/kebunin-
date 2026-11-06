import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../data/mock_data.dart';

class CategoryService extends ChangeNotifier {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  List<Category> _categories = List.from(MockData.categories);
  bool _isLoading = false;
  String? _errorMessage;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CategoryService() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final client = _supabase;
    if (client == null) {
      _categories = List.from(MockData.categories);
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await client
          .from('categories')
          .select()
          .order('name', ascending: true);

      final list = (response as List<dynamic>)
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
      debugPrint('Error fetching categories from Supabase: $e');
      _errorMessage = 'Gagal memuat kategori dari server.';
      if (_categories.isEmpty) {
        _categories = List.from(MockData.categories);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }
}
