import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAndEditCategories extends StatefulWidget {
  const AddAndEditCategories({super.key});

  @override
  State<AddAndEditCategories> createState() => _AddAndEditCategoriesState();
}

class _AddAndEditCategoriesState extends State<AddAndEditCategories> {
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();
  final _brandController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _subCategories = [];
  final List<Map<String, dynamic>> _brands = [];

  int _currentIndex = 0; // Keeps track of the selected tab

  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _subCategoryController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      _categories
          .addAll(List<Map<String, dynamic>>.from(jsonDecode(categoriesJson)));
    }

    final String? subCategoriesJson = prefs.getString('subCategories');
    if (subCategoriesJson != null) {
      _subCategories.addAll(
          List<Map<String, dynamic>>.from(jsonDecode(subCategoriesJson)));
    }

    final String? brandsJson = prefs.getString('brands');
    if (brandsJson != null) {
      _brands.addAll(List<Map<String, dynamic>>.from(jsonDecode(brandsJson)));
    }

    setState(() {});
  }

  void _showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImage(Function(String) onImagePicked) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        onImagePicked(pickedFile.path);
      } else {
        _showMessage('No image selected.', color: Colors.orange);
      }
    } catch (e) {
      _showMessage('Error picking image: $e');
    }
  }

  void _addCategory() async {
    final String categoryName = _categoryController.text.trim();

    if (categoryName.isEmpty) {
      _showMessage('Category name cannot be empty.');
      return;
    }

    final bool exists = _categories.any((category) =>
        category['name'].toLowerCase() == categoryName.toLowerCase());

    if (exists) {
      _showMessage('Category "$categoryName" already exists.');
    } else {
      await _pickImage((imagePath) {
        setState(() {
          _categories.add({
            'name': categoryName,
            'image': imagePath,
          });
          _categoryController.clear();
          _selectedCategory = categoryName;
        });
        _saveData();
        _showMessage('Category "$categoryName" added successfully.',
            color: Colors.green);
      });
    }
  }

  void _addSubCategory() {
    final String subCategoryName = _subCategoryController.text.trim();

    if (subCategoryName.isEmpty) {
      _showMessage('Subcategory name cannot be empty.');
      return;
    }

    final bool exists = _subCategories.any((subCategory) =>
        subCategory['name'].toLowerCase() == subCategoryName.toLowerCase());

    if (exists) {
      _showMessage(
          'Subcategory "$subCategoryName" already exists under "${_selectedCategory!}".');
    } else {
      setState(() {
        _subCategories.add({
          'name': subCategoryName,
        });
        _subCategoryController.clear();
        _selectedSubCategory = subCategoryName;
      });
      _saveData();
      _showMessage('Subcategory "$subCategoryName" added successfully.',
          color: Colors.green);
    }
  }

  void _addBrand() async {
    final String brandName = _brandController.text.trim();

    if (brandName.isEmpty) {
      _showMessage('Brand name cannot be empty.');
      return;
    }

    final bool exists = _brands
        .any((brand) => brand['name'].toLowerCase() == brandName.toLowerCase());

    if (exists) {
      _showMessage('Brand "$brandName" already exists.');
    } else {
      await _pickImage((imagePath) {
        setState(() {
          _brands.add({
            'name': brandName,
            'image': imagePath,
          });
          _brandController.clear();
          _selectedBrand = brandName;
        });
        _saveData();
        _showMessage('Brand "$brandName" added successfully.',
            color: Colors.green);
      });
    }
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String categoriesJson = jsonEncode(_categories);
    await prefs.setString('categories', categoriesJson);

    final String subCategoriesJson = jsonEncode(_subCategories);
    await prefs.setString('subCategories', subCategoriesJson);

    final String brandsJson = jsonEncode(_brands);
    await prefs.setString('brands', brandsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        centerTitle: true,
      ),
      body: _buildTabContent(), // Render content based on the selected tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current tab
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Colors.black),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.black),
            label: 'Subcategories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store, color: Colors.black),
            label: 'Brands',
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildSection(
          title: 'Categories',
          controller: _categoryController,
          label: 'Add Category',
          icon: Icons.category,
          onSubmit: (value) => _addCategory(),
          items: _categories,
          onEditItem: (items) {},
        );
      case 1:
        return _buildSection(
          title: 'Subcategories',
          controller: _subCategoryController,
          label: 'Add Subcategory',
          icon: Icons.safety_check,
          onSubmit: (value) => _addSubCategory(),
          items: _subCategories,
          onEditItem: (items) {},
        );
      case 2:
        return _buildSection(
          title: 'Brands',
          controller: _brandController,
          label: 'Add Brand',
          icon: Icons.store,
          onSubmit: (value) => _addBrand(),
          items: _brands,
          onEditItem: (items) {},
        );
      default:
        return Container();
    }
  }

  Widget _buildSection({
    required String title,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onSubmit,
    required List<Map<String, dynamic>> items,
    required Function(Map<String, dynamic>) onEditItem,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: controller,
            label: label,
            icon: icon,
            onSubmit: onSubmit,
          ),
          const SizedBox(height: 20),
          if (items.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: item['image'] != null
                      ? Image.file(
                          File(item['image']),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(item['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEditItem(item),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onSubmit,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon),
          ),
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => onSubmit(controller.text),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
