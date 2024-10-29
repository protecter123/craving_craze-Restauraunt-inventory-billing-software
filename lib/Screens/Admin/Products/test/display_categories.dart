import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage_categories_and_all.dart';

class Category2 extends StatefulWidget {
  const Category2({super.key});

  @override
  Category2State createState() => Category2State();
}

class Category2State extends State<Category2> {
  final _categoryController = TextEditingController();
  final _subCategoryController = TextEditingController();
  final _brandController = TextEditingController();

  final List<Map<String, dynamic>> _categories = [];
  final Map<String, List<Map<String, dynamic>>> _subCategories = {};
  final List<Map<String, dynamic>> _brands = [];

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

  void _showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
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

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? categoriesJson = prefs.getString('categories');
    if (categoriesJson != null) {
      _categories
          .addAll(List<Map<String, dynamic>>.from(jsonDecode(categoriesJson)));
    }

    final String? subCategoriesJson = prefs.getString('subCategories');
    if (subCategoriesJson != null) {
      final Map<String, dynamic> decodedMap = jsonDecode(subCategoriesJson);
      decodedMap.forEach((key, value) {
        _subCategories[key] = List<Map<String, dynamic>>.from(value);
      });
    }

    final String? brandsJson = prefs.getString('brands');
    if (brandsJson != null) {
      _brands.addAll(List<Map<String, dynamic>>.from(jsonDecode(brandsJson)));
    }

    setState(() {});
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
          _subCategories[categoryName] = [];
          _categoryController.clear();
          _selectedCategory = categoryName;
          _selectedSubCategory = null;
        });
        _saveData();
        _showMessage('Category "$categoryName" added successfully.',
            color: Colors.green);
      });
    }
  }

  void _addSubCategory() {
    final String subCategoryName = _subCategoryController.text.trim();

    if (_selectedCategory == null) {
      _showMessage('Please select a category first.');
      return;
    }

    if (subCategoryName.isEmpty) {
      _showMessage('Subcategory name cannot be empty.');
      return;
    }

    final List<Map<String, dynamic>> subCategoryList =
        _subCategories[_selectedCategory!] ?? [];

    final bool exists = subCategoryList.any((subCategory) =>
        subCategory['name'].toLowerCase() == subCategoryName.toLowerCase());

    if (exists) {
      _showMessage(
          'Subcategory "$subCategoryName" already exists under "${_selectedCategory!}".');
    } else {
      setState(() {
        subCategoryList.add({
          'name': subCategoryName,
        });
        _subCategories[_selectedCategory!] = subCategoryList;
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

  void _editItem(
      {String? categoryName,
      String? subCategoryName,
      String? brandName,
      String? imagePath,
      required String editType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(
          categoryName: categoryName,
          subCategoryName: subCategoryName,
          brandName: brandName,
          imagePath: imagePath,
          isEditing: true,
          editType: editType,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(),
            const SizedBox(height: 30),
            _buildSubCategorySection(),
            const SizedBox(height: 30),
            _buildBrandSection(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _editItem(editType: 'category'),
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildCategorySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTextField(
              controller: _categoryController,
              label: 'Add Category',
              icon: Icons.category,
              onSubmit: (value) => _addCategory(),
            ),
            const SizedBox(height: 20),
            if (_categories.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Row(
                      children: [
                        Image.file(
                          File(category['image']),
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 10),
                        Text(category['name']),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editItem(
                            categoryName: category['name'],
                            imagePath: category['image'],
                            editType: 'category',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _selectedSubCategory = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategorySection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subcategories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTextField(
              controller: _subCategoryController,
              label: 'Add Subcategory',
              icon: Icons.subdirectory_arrow_right,
              onSubmit: (value) => _addSubCategory(),
            ),
            const SizedBox(height: 20),
            if (_selectedCategory != null)
              DropdownButtonFormField<String>(
                value: _selectedSubCategory,
                decoration: const InputDecoration(
                  labelText: 'Select Subcategory',
                  border: OutlineInputBorder(),
                ),
                items: _subCategories[_selectedCategory!]?.map((subCategory) {
                  return DropdownMenuItem<String>(
                    value: subCategory['name'],
                    child: Row(
                      children: [
                        Text(subCategory['name']),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editItem(
                            subCategoryName: subCategory['name'],
                            editType: 'subcategory',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubCategory = value;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTextField(
              controller: _brandController,
              label: 'Add Brand',
              icon: Icons.branding_watermark,
              onSubmit: (value) => _addBrand(),
            ),
            const SizedBox(height: 20),
            if (_brands.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: const InputDecoration(
                  labelText: 'Select Brand',
                  border: OutlineInputBorder(),
                ),
                items: _brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand['name'],
                    child: Row(
                      children: [
                        Image.file(
                          File(brand['image']),
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 10),
                        Text(brand['name']),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editItem(
                            brandName: brand['name'],
                            imagePath: brand['image'],
                            editType: 'brand',
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onSubmit,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      onSubmitted: onSubmit,
    );
  }
}
