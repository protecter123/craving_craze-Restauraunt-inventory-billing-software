import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  final String? categoryName;
  final String? subCategoryName;
  final String? brandName;
  final String? imagePath;
  final bool isEditing;
  final String? editType;

  const AddPage({
    super.key,
    this.categoryName,
    this.subCategoryName,
    this.brandName,
    this.imagePath,
    this.isEditing = false,
    this.editType,
  });

  @override
  AddPageState createState() => AddPageState();
}

class AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _nameController.text = widget.categoryName ??
          widget.subCategoryName ??
          widget.brandName ??
          '';
      _imagePath = widget.imagePath;
      if (_imagePath != null) {
        _imageFile = File(_imagePath!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> categories = [];
    List<Map<String, dynamic>> subCategories = [];
    List<Map<String, dynamic>> brands = [];

    final String name = _nameController.text;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    if (widget.editType == 'category') {
      final String? categoriesJson = prefs.getString('categories');
      if (categoriesJson != null) {
        categories =
            List<Map<String, dynamic>>.from(jsonDecode(categoriesJson));
      }
      if (widget.isEditing) {
        final index =
            categories.indexWhere((c) => c['name'] == widget.categoryName);
        if (index != -1) {
          categories[index] = {
            'name': name,
            'image': _imagePath,
          };
        }
      } else {
        categories.add({
          'name': name,
          'image': _imagePath,
        });
      }
      await prefs.setString('categories', jsonEncode(categories));
    } else if (widget.editType == 'subcategory') {
      final String? subCategoriesJson = prefs.getString('subCategories');
      if (subCategoriesJson != null) {
        final Map<String, dynamic> decodedMap = jsonDecode(subCategoriesJson);
        decodedMap.forEach((key, value) {
          subCategories.addAll(
            List<Map<String, dynamic>>.from(value),
          );
        });
      }
      if (widget.isEditing) {
        final List<Map<String, dynamic>> categorySubs = subCategories
            .where((sc) => sc['category'] == widget.categoryName)
            .toList();
        final index = categorySubs
            .indexWhere((sc) => sc['name'] == widget.subCategoryName);
        if (index != -1) {
          categorySubs[index] = {
            'name': name,
            'image': _imagePath,
            'category': widget.categoryName,
          };
          subCategories
              .removeWhere((sc) => sc['category'] == widget.categoryName);
          subCategories.addAll(categorySubs);
        }
      } else {
        subCategories.add({
          'name': name,
          'image': _imagePath,
          'category': widget.categoryName,
        });
      }
      final Map<String, dynamic> updatedSubCategories = {};
      for (var subCategory in subCategories) {
        final category = subCategory['category'];
        if (updatedSubCategories.containsKey(category)) {
          updatedSubCategories[category]!.add(subCategory);
        } else {
          updatedSubCategories[category] = [subCategory];
        }
      }
      await prefs.setString('subCategories', jsonEncode(updatedSubCategories));
    } else if (widget.editType == 'brand') {
      final String? brandsJson = prefs.getString('brands');
      if (brandsJson != null) {
        brands = List<Map<String, dynamic>>.from(jsonDecode(brandsJson));
      }
      if (widget.isEditing) {
        final index = brands.indexWhere((b) => b['name'] == widget.brandName);
        if (index != -1) {
          brands[index] = {
            'name': name,
            'image': _imagePath,
          };
        }
      } else {
        brands.add({
          'name': name,
          'image': _imagePath,
        });
      }
      await prefs.setString('brands', jsonEncode(brands));
    }

    Navigator.pop(context, true); // Indicate that changes were made
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing
            ? 'Edit ${widget.editType}'
            : 'Add ${widget.editType}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              )
            else if (_imagePath != null)
              Image.network(
                _imagePath!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveData,
              child: Text(
                  widget.isEditing ? 'Save Changes' : 'Add ${widget.editType}'),
            ),
          ],
        ),
      ),
    );
  }
}
