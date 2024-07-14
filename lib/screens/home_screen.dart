import 'package:ecommercepart/screens/searchscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/filter_widget.dart';
import '../widgets/product_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = 'All';
  String _selectedPriceRange = 'All';
  String _selectedSubCategory = 'All';
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch products after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });
  }

  Future<void> _fetchProducts() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsByFilters(_selectedCategoryId, _selectedPriceRange, _selectedSubCategory);
  }

  void _applyFilter(String category, String priceRange, String subCategory) {
    setState(() {
      _selectedCategoryId = category;
      _selectedPriceRange = priceRange;
      _selectedSubCategory = subCategory;
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ecomp',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add_alt_1_rounded, size: 33),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              _searchController.clear();
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.amber[700],
        onRefresh: _fetchProducts,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.yellow, style: BorderStyle.solid),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchProducts(_searchController.text);
                      },
                    ),
                  ),
                  onSubmitted: _searchProducts,
                ),
              ),
              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    padding: const EdgeInsets.all(1.0), // Fix the error here
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 9.0),
                          child: Text(
                            'Recommended Products',
                            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ),
                        productProvider.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : productProvider.products.isEmpty
                            ? _buildDefaultContainers()
                            : ProductList(productProvider.products),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        child: Icon(Icons.chat),
        backgroundColor: Colors.amber[700],
      ),
    );
  }

  void _searchProducts(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(query: query),
        ),
      );
    }
  }

  Widget _buildDefaultContainers() {
    return Column(
      children: List.generate(
        5,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContainer(index * 2),
              _buildContainer(index * 2 + 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(int index) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    // Create a dummy product for demonstration (you might use real product data here)
    final dummyProduct = Product(
      id: '$index',
      name: 'Default Container $index',
      category: 'Default Category',
      description: 'Lorem ipsum dolor sit amet',
      imageUrl: 'https://picsum.photos/200?random=$index',
      price: 1.0,
      rating: 0,
      stockQuantity: 10,
    );

    return Expanded(
      flex: 1, // Each container takes equal space
      child: Padding(
        padding: EdgeInsets.all(5.9),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: dummyProduct),
              ),
            );
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    dummyProduct.imageUrl,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200], // Placeholder color
                      child: Icon(Icons.error),
                    ),
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 13),
                // Product Name and Like Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          dummyProduct.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        productProvider.isFavorite(dummyProduct) ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: productProvider.isFavorite(dummyProduct) ? Colors.red : null,
                      onPressed: () {
                        productProvider.toggleFavorite(dummyProduct);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 13),
                // Product Details
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    dummyProduct.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter'),
        content: FilterWidget(
          initialCategory: _selectedCategoryId,
          initialPriceRange: _selectedPriceRange,
          initialSubCategory: _selectedSubCategory,
          onFilterChanged: _applyFilter,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}