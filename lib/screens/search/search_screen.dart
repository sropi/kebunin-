import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  final String initialQuery;

  const SearchScreen({super.key, this.initialQuery = ''});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  final List<String> _popularKeywords = [
    'Bayam',
    'Wortel',
    'Brokoli',
    'Tomat',
    'Cabai Rawit',
    'Kangkung',
    'Kentang',
    'Paket Sop',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductService>().setSearchQuery(widget.initialQuery);
      context.read<ProductService>().selectCategory('cat_all');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<ProductService>().setSearchQuery(value);
  }

  void _applyKeyword(String keyword) {
    _searchController.text = keyword;
    context.read<ProductService>().setSearchQuery(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.watch<ProductService>();
    final results = productService.filteredProducts;
    final query = productService.searchQuery;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: AppBar(
        backgroundColor: KebuninColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: KebuninColors.charcoal),
          onPressed: () {
            productService.setSearchQuery('');
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            height: 42,
            decoration: BoxDecoration(
              color: KebuninColors.warmCream,
              borderRadius: BorderRadius.circular(KebuninRadius.md),
              border: Border.all(color: KebuninColors.border),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: widget.initialQuery.isEmpty,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari sayur segar nusantara...',
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 20, color: KebuninColors.forestGreen),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: KebuninColors.mutedGrey),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: KebuninColors.border, height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Search Chips
          Container(
            color: KebuninColors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 16, color: KebuninColors.forestGreen),
                    SizedBox(width: 6),
                    Text(
                      'Pencarian Populer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: KebuninColors.charcoal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _popularKeywords.map((keyword) {
                    final isCurrent =
                        query.toLowerCase() == keyword.toLowerCase();
                    return InkWell(
                      onTap: () => _applyKeyword(keyword),
                      borderRadius: BorderRadius.circular(KebuninRadius.pill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? KebuninColors.forestGreen
                              : KebuninColors.warmCream,
                          borderRadius:
                              BorderRadius.circular(KebuninRadius.pill),
                          border: Border.all(
                            color: isCurrent
                                ? KebuninColors.forestGreen
                                : KebuninColors.border,
                          ),
                        ),
                        child: Text(
                          keyword,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isCurrent
                                ? KebuninColors.white
                                : KebuninColors.charcoal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Search Results Header
          if (query.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Text(
                'Menampilkan ${results.length} hasil untuk "$query"',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: KebuninColors.charcoal,
                ),
              ),
            ),

          // Grid Results or Empty State
          Expanded(
            child: results.isEmpty
                ? _buildEmptyState(query)
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final product = results[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                            arguments: product,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: KebuninColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KebuninColors.border),
              ),
              child: const Icon(
                Icons.nature_people_outlined,
                size: 40,
                color: KebuninColors.leafGreen,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'Mulai mengetik untuk mencari sayur'
                  : 'Sayur "$query" tidak ditemukan',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: KebuninColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Coba gunakan kata kunci umum seperti "Bayam", "Wortel", atau periksa ejaan Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: KebuninColors.mutedGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

