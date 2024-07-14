import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final String initialCategory;
  final String initialPriceRange;
  final String initialSubCategory;
  final Function(String category, String priceRange, String subCategory) onFilterChanged;

  FilterWidget({
    required this.initialCategory,
    required this.initialPriceRange,
    required this.initialSubCategory,
    required this.onFilterChanged,
  });

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late String _selectedCategory;
  late String _selectedPriceRange;
  late String _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _selectedPriceRange = widget.initialPriceRange;
    _selectedSubCategory = widget.initialSubCategory;
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = 'All';
      _selectedPriceRange = 'All';
      _selectedSubCategory = 'All';
    });
    widget.onFilterChanged(_selectedCategory, _selectedPriceRange, _selectedSubCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Filters',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),

        // Main category dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            items: <String>['All', 'Category1', 'Category2', 'Category3', 'Category4', 'Category5']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
                widget.onFilterChanged(_selectedCategory, _selectedPriceRange, _selectedSubCategory);
              });
            },
            hint: Text('Main category'),
          ),
        ),
        SizedBox(height: 10),

        // Price range dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedPriceRange,
            items: <String>['All', '0-50', '51-100', '101-150', '151-200']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPriceRange = value!;
                widget.onFilterChanged(_selectedCategory, _selectedPriceRange, _selectedSubCategory);
              });
            },
            hint: Text('Price'),
          ),
        ),
        SizedBox(height: 10),

        // Subcategory dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedSubCategory,
            items: <String>['All', 'subCategory1', 'subCategory2', 'subCategory3', 'subCategory4', 'subCategory5']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value!;
                widget.onFilterChanged(_selectedCategory, _selectedPriceRange, _selectedSubCategory);
              });
            },
            hint: Text('Subcategory'),
          ),
        ),
        SizedBox(height: 10),

        // Clear filters button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: _clearFilters,
            child: Text('Clear Filters'),
          ),
        ),
      ],
    );
  }
}
