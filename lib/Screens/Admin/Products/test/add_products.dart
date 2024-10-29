import 'dart:convert';

import 'package:craving_craze/Utils/Global/global.dart';
import 'package:craving_craze/Utils/utils.dart';
import 'package:craving_craze/Widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage1 extends StatefulWidget {
  final String? productId; // Added productId parameter for editing

  const AddProductPage1({super.key, this.productId});

  @override
  AddProductPage1State createState() => AddProductPage1State();
}

class AddProductPage1State extends State<AddProductPage1> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _mrpController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  final _maxStockController = TextEditingController();
  final _unitsController = TextEditingController();
  final _stocksController = TextEditingController();
  final _dealerPriceController = TextEditingController();
  final _manufacturController = TextEditingController();
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _subCategories = [];
  final List<Map<String, dynamic>> _brands = [];

  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _isEditing = true;
      _loadData();
      _loadProductData();
    }
  }

  Future<void> _loadcat() async {
    await FirebaseFirestore.instance
        .collection('Admins')
        .doc(SharedPreferencesHelper.getString('adminNumber'))
        .collection('Categories')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        _categories.add({
          'id': doc.id,
          'name': doc.data()['name'],
        });
      }
    });
  }

  Future<void> _loadProductData() async {
    try {
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(SharedPreferencesHelper.getString('adminNumber'))
          .collection('Products')
          .doc(widget.productId)
          .get();

      if (productSnapshot.exists) {
        final data = productSnapshot.data() as Map<String, dynamic>;

        _productNameController.text = data['name'];
        _productDescriptionController.text = data['description'];
        _mrpController.text = data['mrp'].toString();
        _salePriceController.text = data['salePrice'].toString();
        _wholesalePriceController.text = data['wholesalePrice'].toString();
        _discountedPriceController.text = data['discountedPrice'].toString();
        _productCodeController.text = data['productCode'].toString();
        _quantityController.text = data['quantity'].toString();
        _minStockController.text = data['minStock'].toString();
        _maxStockController.text = data['maxStock'].toString();
        _unitsController.text = data['units'];
        _stocksController.text = data['stocks'];
        _dealerPriceController.text = data['dealerPrice'].toString();
        _manufacturController.text = data['manufactur'];
        // _selectedCategory = data['category'];
        // _selectedSubCategory = data['subcategory'];
        // _selectedBrand = data['brand'];
        print(
            'lkaslj$_selectedBrand,$_selectedCategory,$_selectedSubCategory,lkajfa Products cat');
        // Load existing image URLs if needed
        // Set `_imageFiles` if you need to handle existing images
      }
    } catch (e) {
      print("Error loading product data: $e");
    }
  }
  // Future<void> _loadData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   final String? categoriesJson = prefs.getString('categories');
  //   if (categoriesJson != null) {
  //     _categories
  //         .addAll(List<Map<String, dynamic>>.from(jsonDecode(categoriesJson)));
  //   }

  //   final String? subCategoriesJson = prefs.getString('subCategories');
  //   if (subCategoriesJson != null) {
  //     _subCategories.addAll(List<Map<String,dynamic>>.from(jsonDecode(subCategoriesJson)) );
  //     // final Map<String, dynamic> decodedMap = jsonDecode(subCategoriesJson);
  //     // decodedMap.forEach((key, value) {
  //     //   _subCategories[key] = List<Map<String, dynamic>>.from(value);
  //     // });
  //   }

  //   final String? brandsJson = prefs.getString('brands');
  //   if (brandsJson != null) {
  //     _brands.addAll(List<Map<String, dynamic>>.from(jsonDecode(brandsJson)));
  //   }

  //   setState(() {});
  // }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final productName = _productNameController.text;
      final productDescription = _productDescriptionController.text;
      final mrp = double.tryParse(_mrpController.text) ?? 0.0;
      final salePrice = double.tryParse(_salePriceController.text) ?? 0.0;
      final wholesalePrice =
          double.tryParse(_wholesalePriceController.text) ?? 0.0;
      final discountedPrice =
          double.tryParse(_discountedPriceController.text) ?? 0.0;
      final productCode = int.tryParse(_productCodeController.text) ?? 0;
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final minStock = int.tryParse(_minStockController.text) ?? 0;
      final maxStock = int.tryParse(_maxStockController.text) ?? 0;
      final units = _unitsController.text;
      final stocks = _stocksController.text;
      final dealerPrice = double.tryParse(_dealerPriceController.text) ?? 0.0;
      final manufactur = _manufacturController.text;

      // Upload images and get URLs
      List<String> imageUrls = await _uploadImages(_imageFiles);
      String? number = SharedPreferencesHelper.getString('adminNumber');

      try {
        if (_isEditing) {
          // Update existing product
          await FirebaseFirestore.instance
              .collection('Admins')
              .doc(number)
              .collection('Products')
              .doc(widget.productId)
              .update({
            'name': productName,
            'description': productDescription,
            'mrp': mrp,
            'salePrice': salePrice,
            'wholesalePrice': wholesalePrice,
            'discountedPrice': discountedPrice,
            'images': imageUrls,
            'minStock': minStock,
            'quantity': quantity,
            'category': _selectedCategory,
            'subcategory': _selectedSubCategory,
            'brand': _selectedBrand,
            'maxStock': maxStock,
            'units': units,
            'stocks': stocks,
            'dealerPrice': dealerPrice,
            'manufactur': manufactur,
            'productCode': productCode,
            'deleted': false
          });
        } else {
          // Add new product
          await FirebaseFirestore.instance
              .collection('Admins')
              .doc(number)
              .collection('Products')
              .add({
            'name': productName,
            'description': productDescription,
            'mrp': mrp,
            'salePrice': salePrice,
            'wholesalePrice': wholesalePrice,
            'discountedPrice': discountedPrice,
            'images': imageUrls,
            'createdAt': Timestamp.now(),
            'isActive': false,
            'minStock': minStock,
            'quantity': quantity,
            'category': _selectedCategory,
            'subcategory': _selectedSubCategory,
            'brand': _selectedBrand,
            'maxStock': maxStock,
            'units': units,
            'stocks': stocks,
            'dealerPrice': dealerPrice,
            'manufactur': manufactur,
            'productCode': productCode,
            'deleted': false
          });
          await FirebaseFirestore.instance
              .collection('Admins')
              .doc(number)
              .update({
            'productCategories': [_selectedCategory],
            'subCategories': FieldValue.arrayUnion([_selectedSubCategory]),
            'brands': FieldValue.arrayUnion([_selectedBrand]),
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_isEditing
                  ? 'Product updated successfully!'
                  : 'Product added successfully!')),
        );
        // Clear form
        _productNameController.clear();
        _productDescriptionController.clear();
        _mrpController.clear();
        _salePriceController.clear();
        _wholesalePriceController.clear();
        _discountedPriceController.clear();
        setState(() {
          _imageFiles = [];
        });
        Navigator.pop(context);
      } catch (e) {
        print("Error ${_isEditing ? 'updating' : 'adding'} product: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add or update product')),
        );
      }
    }
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
      // final Map<String, dynamic> decodedMap = jsonDecode(subCategoriesJson);
      // decodedMap.forEach((key, value) {
      //   _subCategories[key] = List<Map<String, dynamic>>.from(value);
      // });
    }

    final String? brandsJson = prefs.getString('brands');
    if (brandsJson != null) {
      _brands.addAll(List<Map<String, dynamic>>.from(jsonDecode(brandsJson)));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            TyperAnimatedText(
              speed: Durations.extralong1,
              _isEditing ? 'Edit' : 'Add',
            ),
            TyperAnimatedText(
              _isEditing ? 'Product' : 'Product',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimationLimiter(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const RadialGradient(
                        colors: [m, lm],
                        radius: 2,
                        tileMode: TileMode.mirror,
                        center: Alignment.center,
                      ).createShader(bounds);
                    },
                    child: Text(
                      _isEditing ? 'Edit Product' : 'Add a New Product',
                      style: textTheme.headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  Gap.h(10),
                  if (_selectedCategory != null)
                    _buildDropdownButton(_selectedCategory!, _categories),
                  const SizedBox(height: 16.0),
                  if (_selectedSubCategory != null)
                    _buildDropdownButton(_selectedSubCategory!, _subCategories),
                  const SizedBox(height: 16.0),
                  if (_selectedBrand != null)
                    _buildDropdownButton(_selectedBrand!, _brands),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _productNameController,
                      label: 'Product Name'),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _productNameController,
                      label: 'Product Barcode'),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _productDescriptionController,
                      label: 'Product Description',
                      maxLines: 3),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _mrpController,
                      label: 'MRP',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _salePriceController,
                      label: 'Sale Price',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _wholesalePriceController,
                      label: 'Wholesale Price',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _discountedPriceController,
                      label: 'Discounted Price',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _productCodeController,
                      label: 'Product Code',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _quantityController,
                      label: 'Quantity',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _minStockController,
                      label: 'Min Stock',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _maxStockController,
                      label: 'Max Stock',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(controller: _unitsController, label: 'Units'),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _stocksController, label: 'Stocks'),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _dealerPriceController,
                      label: 'Dealer Price',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                      controller: _manufacturController, label: 'Manufacturer'),
                  const SizedBox(height: 16.0),
                  DottedBorderContainer(
                    width: MediaQuery.of(context).size.width * 10,
                    height: MediaQuery.of(context).size.height * .2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: _pickImage,
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 8.0,
                            children: _imageFiles.map((file) {
                              return Image.file(
                                file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(_isEditing ? 'Update Product' : 'Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _imageFiles = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future<List<String>> _uploadImages(List<File> imageFiles) async {
    List<String> imageUrls = [];
    for (var imageFile in imageFiles) {
      final fileName = path.basename(imageFile.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('product_images/$fileName');

      try {
        final uploadTask = storageRef.putFile(imageFile);
        final snapshot = await uploadTask.whenComplete(() {});
        final imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

  Widget _buildDropdownButton(
      String selectedItem, List<Map<String, dynamic>> items) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      decoration: const InputDecoration(
        labelText: 'Select ',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          selectedItem = value!;
        });
      },
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item['name'],
          child: Row(
            children: [
              item['image'] != null
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
              const SizedBox(width: 10),
              Text(item['name']),
              // IconButton(
              //   icon: const Icon(Icons.edit),
              //   onPressed: () => _editItem(
              //     categoryName: category['name'],
              //     imagePath: category['image'],
              //     editType: 'category',
              //   ),
              // ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
