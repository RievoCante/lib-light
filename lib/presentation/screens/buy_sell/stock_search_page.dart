// Stock search page - simple search with live filtering
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/stock_list_item.dart';
import '../../widgets/stock/stock_list_tile.dart';
import 'stock_detail_page.dart';

class StockSearchPage extends StatefulWidget {
  final List<StockListItem> allStocks;
  final String marketType;

  const StockSearchPage({
    super.key,
    required this.allStocks,
    required this.marketType,
  });

  @override
  State<StockSearchPage> createState() => _StockSearchPageState();
}

class _StockSearchPageState extends State<StockSearchPage> {
  final _searchController = TextEditingController();
  List<StockListItem> _filteredStocks = [];

  @override
  void initState() {
    super.initState();
    _filteredStocks = widget.allStocks;
    _searchController.addListener(_filterStocks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStocks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStocks = widget.allStocks;
      } else {
        _filteredStocks = widget.allStocks.where((stock) {
          return stock.symbol.toLowerCase().contains(query) ||
              stock.fullName.toLowerCase().contains(query) ||
              stock.shortName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
      body: _filteredStocks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 16),
                  Text('No results found', style: AppTextStyles.bodyMedium),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredStocks.length,
              itemBuilder: (context, index) {
                final stock = _filteredStocks[index];
                return StockListTile(
                  stock: stock,
                  onTap: () {
                    Navigator.pop(context); // Close search
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockDetailPage(
                          stockItem: stock,
                          marketType: widget.marketType,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
