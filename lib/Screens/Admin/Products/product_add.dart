// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// import '../../../Utils/utils.dart';

// class AddProduct extends StatefulWidget {
//   const AddProduct({super.key});

//   @override
//   AddProductState createState() => AddProductState();
// }

// class AddProductState extends State<AddProduct> {
//   final _formKey = GlobalKey<FormState>();
//   final _productNameController = TextEditingController();
//   final _productDescriptionController = TextEditingController();
//   final _productPriceController = TextEditingController();
//   List<File> _imageFiles = [];
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _imageFiles = pickedFiles.map((file) => File(file.path)).toList();
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Process and save the data
//       final productName = _productNameController.text;
//       final productDescription = _productDescriptionController.text;
//       final productPrice = double.tryParse(_productPriceController.text) ?? 0.0;

//       // Example of how to handle the data
//       print('Product Name: $productName');
//       print('Product Description: $productDescription');
//       print('Product Price: $productPrice');
//       print('Number of Images: ${_imageFiles.length}');

//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Product'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 TextFormField(
//                   controller: _productNameController,
//                   decoration: const InputDecoration(labelText: 'Product Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter product name';
//                     }
//                     return null;
//                   },
//                 ),
//                                 Gap.h(20),

//                 TextFormField(
//                   controller: _productDescriptionController,
//                   decoration: const InputDecoration(labelText: 'Product Description'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter product description';
//                     }
//                     return null;
//                   },
//                 ),
//                 Gap.h(20),
//                 TextFormField(
//                   controller: _productPriceController,
//                   decoration: const InputDecoration(labelText: 'Product Price'),
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter product price';
//                     }
//                     if (double.tryParse(value) == null) {
//                       return 'Please enter a valid price';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _pickImages,
//                   child: const Text('Pick Images'),
//                 ),
//                 const SizedBox(height: 16.0),
//                 _imageFiles.isEmpty
//                     ? const Text('No images selected.')
//                     : Wrap(
//                         spacing: 8.0,
//                         runSpacing: 8.0,
//                         children: _imageFiles.map((file) {
//                           return Image.file(
//                             file,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           );
//                         }).toList(),
//                       ),
//                 const SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: const Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: () {
              // Handle export action
            },
          ),
          IconButton(
            icon: const Icon(Icons.import_contacts),
            onPressed: () {
              // Handle import action
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 1200) {
            return _buildDesktopLayout();
          } else if (constraints.maxWidth >= 768) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: _buildSidebar()),
          Expanded(flex: 4, child: _buildProductTable()),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildProductTable()),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildProductTable()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 20),
          _buildColumnsSettings(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search users',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filters', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Handle filters
          },
          icon: const Icon(Icons.filter_list),
          label: const Text('Apply Filters'),
          style: ElevatedButton.styleFrom(
            // primary: Colors.blue,
            // onPrimary: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildColumnsSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Columns', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Handle columns customization
          },
          icon: const Icon(Icons.view_column),
          label: const Text('Customize Columns'),
          style: ElevatedButton.styleFrom(
            // primary: Colors.blue,
            // onPrimary: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildProductTable() {
    return ListView.builder(
      itemCount: 5, // Replace with dynamic count
      itemBuilder: (context, index) {
        return _buildProductRow(context);
      },
    );
  }

  Widget _buildProductRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Checkbox(value: true, onChanged: (value) {}),
          Image.network(
            'https://via.placeholder.com/50', // Replace with product image
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Name',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Electronics',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // splashRadius:100,
              value: false,
              onChanged: (value) {}),
          const SizedBox(width: 10),
          const Text(
            r'$65',
            style: TextStyle(),
          ),
          const SizedBox(width: 10),
          // IconButton(
          //   icon: Icon(Icons.edit,),
          //   onPressed: () {
          //     // Handle edit action
          //   },
          // ),
          popup(context)
        ],
      ),
    );
  }
}

Widget popup(BuildContext context) {
  return PopupMenuButton<String>(
    onSelected: (String value) {
      // Handle the selected value
      print('Selected: $value');
    },
    itemBuilder: (BuildContext context) {
      return [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              // Icon(Icons.edit),
              // SizedBox(width: 10),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              // Icon(Icons.delete),
              // SizedBox(width: 10),
              Text('Delete'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'archive',
          child: Row(
            children: [
              // Icon(Icons.archive),
              // SizedBox(width: 10),
              Text('Archive'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'publish',
          child: Row(
            children: [
              // Icon(Icons.upload),
              // SizedBox(width: 10),
              Text('Publish'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'unpublish',
          child: Row(
            children: [
              // Icon(Icons.close),
              // SizedBox(width: 10),
              Text('Unpublish'),
            ],
          ),
        ),
      ];
    },
    child: const Row(
      children: [
        // Icon(Icons.edit),
        // SizedBox(width: 10),
        Text('Edit'),
        Icon(Icons.arrow_drop_down),
      ],
    ),
  );
}
