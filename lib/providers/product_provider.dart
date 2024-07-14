import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final List<Product> _purchasedProducts = [];
  bool _isLoading = false;
  List<Category> _categories = [];
  String _selectedCategoryId = '1'; // Default selected category id
  String _selectedPriceRange = 'All'; // Default selected price range
  String _selectedSubCategory = 'All'; // Default selected subcategory
  List<Product> _favorites = [];

  // Define default categories
  final List<Category> _defaultCategories = [
    Category(id: '1', name: 'Category 1'),
    Category(id: '2', name: 'Category 2'),
    Category(id: '3', name: 'Category 3'),
    Category(id: '4', name: 'Category 4'),
    Category(id: '5', name: 'Category 5'),
  ];

  List<Product> get products => _products.where((product) => !_purchasedProducts.contains(product)).toList();
  bool get isLoading => _isLoading;
  List<Category> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedPriceRange => _selectedPriceRange; // Getter for selected price range
  String get selectedSubCategory => _selectedSubCategory; // Getter for selected subcategory
  List<Product> get favorites => _favorites;

  ProductProvider() {
    _categories.addAll(_defaultCategories);
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Product> fetchedProducts = await ApiService().fetchProductsByCategory(_selectedCategoryId);

      if (fetchedProducts.isEmpty) {
        _products = List.generate(
          10,
              (index) => Product(
            id: '$index',
            name: 'Default Container $index',
            category: 'Default Category',
            description: 'Lorem ipsum dolor sit amet',
            imageUrl: 'https://picsum.photos/200?random=$index',
            price: 0.0,
            rating: 0.0,
            stockQuantity: 10,
          ),
        );
      } else {
        _products = fetchedProducts;
      }
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByFilters(String categoryId, String priceRange, String subCategory) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Product> fetchedProducts = await ApiService().fetchProductsByFilters(categoryId, priceRange, subCategory);

      _products = fetchedProducts.isEmpty
          ? List.generate(
        10,
            (index) => Product(
          id: '$index',
          name: 'Default Container $index',
          category: 'Default Category',
          description: 'Lorem ipsum dolor sit amet',
          imageUrl: 'https://picsum.photos/200?random=$index',
          price: 50 + index * 10,
          rating: 4.5, // Ensure this matches the double type
          stockQuantity: 100,
        ),
      ).where((product) {
        bool matchesCategory = categoryId == 'All' || product.category == categoryId;
        bool matchesPriceRange = priceRange == 'All' ||
            (priceRange == '0-50' && product.price <= 50 ||
                priceRange == '51-100' && product.price > 50 && product.price <= 100 ||
                priceRange == '101-150' && product.price > 100 && product.price <= 150 ||
                priceRange == '151-200' && product.price > 150 && product.price <= 200);
        bool matchesSubCategory = subCategory == 'All' || product.category == subCategory;
        return matchesCategory && matchesPriceRange && matchesSubCategory;
      }).toList()
          : fetchedProducts;
    } catch (error) {
      print('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    fetchProducts();
  }

  void addFavorite(Product product) {
    if (!_favorites.any((item) => item.id == product.id)) {
      _favorites.add(product);
      ApiService().addToFavorites(product);
      notifyListeners();
    }
  }

  void removeFavorite(Product product) {
    _favorites.removeWhere((item) => item.id == product.id);
    ApiService().removeFromFavorites(product);
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.any((item) => item.id == product.id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeFavorite(product);
    } else {
      addFavorite(product);
    }
  }

  void hidePurchasedProducts(List<Product> purchasedProducts) {
    _purchasedProducts.addAll(purchasedProducts);
    notifyListeners();
  }
}