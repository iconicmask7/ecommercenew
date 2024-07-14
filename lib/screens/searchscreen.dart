import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/search_service.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  SearchService _searchService = SearchService();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    _performSearch(widget.query);
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> results = await _searchService.searchProducts(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Handle error (e.g., show error message)
        print('Error searching products: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Search'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (ctx, index) => ListTile(
                leading: Image.network(_searchResults[index].imageUrl),
                title: Text(_searchResults[index].name),
                subtitle: Text('\$${_searchResults[index].price.toStringAsFixed(2)}'),
                onTap: () {
                  // Navigate to product detail screen or handle selection
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


