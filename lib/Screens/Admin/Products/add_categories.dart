// import 'package:craving_craze/Widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// import '../../../Utils/Global/global.dart';
// import '../../../Utils/utils.dart';

// class CategoryManagerPage extends StatefulWidget {
//   @override
//   _CategoryManagerPageState createState() => _CategoryManagerPageState();
// }

// class _CategoryManagerPageState extends State<CategoryManagerPage> {
//   final _categoryController = TextEditingController();
//   final _subCategoryController = TextEditingController();
//   final _brandController = TextEditingController();

//   final List<String> _categories = [];
//   final Map<String, List<String>> _subCategories = {};
//   final List<String> _brands = [];

//   String? _selectedCategory;
//   String? _selectedSubCategory;
//   String? _selectedBrand;

//   @override
//   void dispose() {
//     _categoryController.dispose();
//     _subCategoryController.dispose();
//     _brandController.dispose();
//     super.dispose();
//   }

//   void _addCategory() {
//     if (_categoryController.text.isNotEmpty) {
//       setState(() {
//         _categories.add(_categoryController.text);
//         _subCategories[_categoryController.text] = [];
//         _categoryController.clear();
//       });
//     }
//   }

//   void _addSubCategory() {
//     if (_selectedCategory != null && _subCategoryController.text.isNotEmpty) {
//       setState(() {
//         _subCategories[_selectedCategory!]!.add(_subCategoryController.text);
//         _subCategoryController.clear();
//       });
//     }
//   }

//   void _addBrand() {
//     if (_brandController.text.isNotEmpty) {
//       setState(() {
//         _brands.add(_brandController.text);
//         _brandController.clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Categories'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField(
//               controller: _categoryController,
//               label: 'Add Category',
//               onSubmit: _addCategory,
//             ),
//             SizedBox(height: 20),
//             DropdownButton<String>(
//               value: _selectedCategory,
//               hint: Text('Select Category'),
//               isExpanded: true,
//               items: _categories.map((category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategory = value;
//                   _selectedSubCategory = null;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             if (_selectedCategory != null)
//               _buildTextField(
//                 controller: _subCategoryController,
//                 label: 'Add Sub-Category',
//                 onSubmit: _addSubCategory,
//               ),
//             SizedBox(height: 20),
//             if (_selectedCategory != null && _subCategories[_selectedCategory!]!.isNotEmpty)
//               DropdownButton<String>(
//                 value: _selectedSubCategory,
//                 hint: Text('Select Sub-Category'),
//                 isExpanded: true,
//                 items: _subCategories[_selectedCategory!]!.map((subCategory) {
//                   return DropdownMenuItem<String>(
//                     value: subCategory,
//                     child: Text(subCategory),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedSubCategory = value;
//                   });
//                 },
//               ),
//             SizedBox(height: 20),
//             if(_selectedSubCategory != null)
//             _buildTextField(
//               controller: _brandController,
//               label: 'Add Brand',
//               onSubmit: _addBrand,
//             ),
//             SizedBox(height: 20),
//             if (_brands.isNotEmpty)
//               DropdownButton<String>(
//                 value: _selectedBrand,
//                 hint: Text('Select Brand'),
//                 isExpanded: true,
//                 items: _brands.map((brand) {
//                   return DropdownMenuItem<String>(
//                     value: brand,
//                     child: Text(brand),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedBrand = value;
//                   });
//                 },
//               ),
//               SizedBox(height: 70),
//               if(_selectedBrand != null)
//               Center(child: buildImageButton(context, textTheme, 'Next', (){}))
//           ]
//         ),
//       ),
      
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required Function() onSubmit,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               labelText: label,
//               border: OutlineInputBorder(),
//             ),
//             onSubmitted: (_) => onSubmit(),
//           ),
//         ),
//         SizedBox(width: 5),
//         IconButton(
//           icon: Lottie.asset(addCategory,height: 40,width: 40),
//           onPressed: onSubmit,
//         ),
//       ],
//     );
//   }
// }




import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Screens/Admin/Products/add_products.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../../Utils/Global/global.dart';
import '../../../Widgets/widgets.dart';

class Category extends StatefulWidget {
  const Category({super.key,});

  @override
  CategoryState createState() => CategoryState();
}

class CategoryState extends State<Category> {
  final String? number = SharedPreferencesHelper.getString('adminNumber');
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
  void dispose() {
    _categoryController.dispose();
    _subCategoryController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  //   Future<void> _saveSelectedData() {

  //   SharedPreferencesHelper.setString('selectedCategory', _selectedCategory!);
  //   SharedPreferencesHelper.setString('selectedSubCategory', _selectedSubCategory!);
  //   SharedPreferencesHelper.setString('selectedBrand', _selectedBrand!);
  // }


  Future<void> _pickImage(Function(String) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // final imagePath = await uploadImageToFirebaseStorage(pickedFile.path);
      onImagePicked(pickedFile.path);
    }
  }

  void _addCategory(String imagePath) {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _categories.add({
          'name': _categoryController.text,
          'image': imagePath,
        });
        _subCategories[_categoryController.text] = [];
        _categoryController.clear();
      });
    }
  }

  void _addSubCategory() {
    if (_selectedCategory != null && _subCategoryController.text.isNotEmpty) {
      setState(() {
        _subCategories[_selectedCategory!]!.add({
          'name': _subCategoryController.text,
        });
        _subCategoryController.clear();
      });
    }
  }

  void _addBrand(String imagePath) {
    if (_brandController.text.isNotEmpty) {
      setState(() {
        _brands.add({
          'name': _brandController.text,
          'image': imagePath,
        });
        _brandController.clear();
      });
    }
  } 
  Future<void> _uploadAllData() async {
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  // Upload all category images
  final categoryImages = await Future.wait(_categories.map((category) async {
    final ref = storage.ref('Storage/$number/categories/${category['name']}.jpg');
    final file = File(category['image']);
    final uploadTask = ref.putFile(file);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }));

  // Upload all brand images
  final brandImages = await Future.wait(_brands.map((brand) async {
    final ref = storage.ref('Storage/$number/brands/${brand['name']}.jpg');
    final file = File(brand['image']);
    final uploadTask = ref.putFile(file);
    final downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }));

  // Save all data to Firestore
  final batch = firestore.batch();
  final adminRef = firestore.collection('Admins').doc(number);

  // Save categories
  _categories.asMap().forEach((index, category) {
    // final categoryRef = adminRef.collection('categories').doc();
    batch.update(adminRef, {
      'categories':FieldValue.arrayUnion([{'name':category['name'],'image':category['image']}]),
  
    });
  });

  // Save subcategories
  _subCategories.forEach((categoryName, subCategories) {
    subCategories.asMap().forEach((index, subCategory) {
      // final subCategoryRef = adminRef.collection('categories').doc(categoryName).collection('subcategories').doc();
      batch.update(adminRef, {
        'subCategories': FieldValue.arrayUnion([subCategory['name']]),
      });
    });
  });

  // Save brands
  _brands.asMap().forEach((index, brand) {
    // final brandRef = adminRef.collection('brands').doc();
    batch.update(adminRef, {
      'brands':FieldValue.arrayUnion([{'name':brand['name'],'image':brand['image']}]),
    
    });
  });

  await batch.commit();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            _buildCategorySection(),
            const SizedBox(height: 20),
            if (_selectedCategory != null) _buildSubCategorySection(),
            const SizedBox(height: 20),
            _buildBrandSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _categoryController,
          label: 'Add Category',
          onSubmit: () => _pickImage(_addCategory),
        ),
        const SizedBox(height: 20),
        DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text('Select Category'),
          isExpanded: true,
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category['name'],
              child: Row(
                children: [
                  Image.file(
                    File(category['image']),
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(category['name']),
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
    );
  }

  Widget _buildSubCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _subCategoryController,
          label: 'Add Sub-Category',
          onSubmit: _addSubCategory,
        ),
        const SizedBox(height: 20),
        if (_subCategories[_selectedCategory!]!.isNotEmpty)
          DropdownButton<String>(
            value: _selectedSubCategory,
            hint: const Text('Select Sub-Category'),
            isExpanded: true,
            items: _subCategories[_selectedCategory!]!.map((subCategory) {
              return DropdownMenuItem<String>(
                value: subCategory['name'],
                child: Text(subCategory['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value;
              });
            },
          ),
      ],
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _brandController,
          label: 'Add Brand',
          onSubmit: () => _pickImage(_addBrand),
        ),
        const SizedBox(height: 20),
        if (_brands.isNotEmpty)
          DropdownButton<String>(
            value: _selectedBrand,
            hint: const Text('Select Brand'),
            isExpanded: true,
            items: _brands.map((brand) {
              return DropdownMenuItem<String>(
                value: brand['name'],
                child: Row(
                  children: [
                    Image.file(
                      File(brand['image']),
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(brand['name']),
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
          const SizedBox(height: 70),
              if(_selectedBrand != null)
              Center(child: buildImageButton(context, textTheme, 'Next', () async{
                // await uploadImageToFirebaseStorage(context,);
                await _uploadAllData();
                final String brand = _selectedBrand!, category = _selectedCategory!,subCategory =_selectedSubCategory!;
                context.mounted?(context, AddProductPage()):null;
              }))
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Function() onSubmit,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onSubmit,
        ),
      ],
    );
  }
  
}


