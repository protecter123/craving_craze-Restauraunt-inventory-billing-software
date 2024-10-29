import 'package:craving_craze/Utils/Global/global.dart';
import 'package:craving_craze/Utils/utils.dart';
import 'package:craving_craze/Widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
  });

  @override
  AddProductPageState createState() => AddProductPageState();
}

class AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _productBarcodeController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _PriceController = TextEditingController();
  final _CostController = TextEditingController();
  final _Price2Controller = TextEditingController();
  final _Price3Controller = TextEditingController();
  final _productCodeController = TextEditingController();
  
  final _minStockController = TextEditingController();
  final _maxStockController = TextEditingController();
 
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _name3Controller = TextEditingController();
  final TextEditingController _name4Controller = TextEditingController();
  final TextEditingController _name5Controller = TextEditingController();
  Map<String, dynamic>? selectDepart;
  List<File> _imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool _showExtraFields = false;
  bool showPromotion = false;
  String _pricecontrol = '';
  bool _isStockChecked = false;
  List<String> departments = [];
  List<String> groups = [];
  String? _selectedDepartment;

  String selectedType = 'Normal';
  bool isSingleItem = false;
  bool isConsolidation = false;
  bool canBeCondiment = false;
  String? GroupValue;
  String? KPValue;
  String? VATValue;
  String? PercValue;
  String? _selectedGroup;
  String? _selectedKP;
  String? _selectedVAT;
  String? _selectedPerc;
  // Toggle method for button
  void _toggleFieldsVisibility() {
    setState(() {
      _showExtraFields = !_showExtraFields;
    });
  }

  void _togglePromotionVisibility() {
    setState(() {
      showPromotion = !showPromotion;
    });
  }

  Future<void> fetchAndSetProductCode() async {
    // Get the current user's phone number.
    final phoneNumber = SharedPreferencesHelper.getString('adminNumber');

    // Define the path to the Products sub-collection.
    final productsCollection = FirebaseFirestore.instance
        .collection('Admins')
        .doc(phoneNumber)
        .collection('Products');

    // Use Firestore's count aggregation to get the document count efficiently.
    final productCountQuery = await productsCollection.count().get();
    final productCount = productCountQuery.count;

    // Set the TextEditingController's value to the count + 1.
    _productCodeController.text = (productCount! + 1).toString();
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetProductCode();
    _fetchDepartments();
    _fetchGroups();
  }

  Future<void> saveProductData(BuildContext context) async {
    try {
      // Check if productBarcode or price are empty and show SnackBar if so
      if (_productBarcodeController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product Barcode is required")),
        );
        return;
      }
      if (_PriceController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Price is required")),
        );
        return;
      }

      // Start loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Get the current user's phone number
      final currentUser = FirebaseAuth.instance.currentUser;
      final phoneNumber = currentUser?.phoneNumber;

      if (phoneNumber == null) {
        Navigator.pop(context); // Dismiss loading indicator
        throw Exception(
            "User is not authenticated or phone number is unavailable.");
      }

      // Upload images and get URLs
      List<String> imageUrls = await _uploadImages(_imageFiles);

      // Prepare product data
      Map<String, dynamic> productData = {
        'name': _name2Controller.text.trim(),
        'productBarcode': _productBarcodeController.text.trim(),
        'description': _productDescriptionController.text,
        'name 2': _name3Controller.text,
        'name 3': _name4Controller.text,
        'name 4': _name5Controller.text,
        'price': _PriceController.text.trim(),
        'price2': _Price2Controller.text,
        'price3': _Price3Controller.text,
        'cost': _CostController.text,
        'priceControl': _pricecontrol,
        'stock': _maxStockController.text,
        'safeStock': _minStockController.text,
        'selectedDepartment': _selectedDepartment,
        'singleItem': isSingleItem,
        'consolidation': isConsolidation,
        'type': selectedType,
        'canBeCondiment': canBeCondiment,
        'group': _selectedGroup,
        'KP': _selectedKP,
        'VAT': _selectedVAT,
        '%': _selectedPerc,
        'images': imageUrls,
        'createdAt': Timestamp.now(),
        'isActive': false,
        'productCode': _productCodeController.text,
        'deleted': false,
      };

      // Reference to the Products sub-collection for the current user
      final productsCollectionRef = FirebaseFirestore.instance
          .collection('Admins')
          .doc(phoneNumber)
          .collection('Products');

      // Save product data
      await productsCollectionRef.add(productData);

      // Dismiss loading indicator
      Navigator.pop(context);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Success",
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              "Product data saved successfully!",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Dismiss loading indicator if there's an error
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving product data: $e")),
      );
    }
  }

  Future<void> _fetchDepartments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userPhoneNumber = user.phoneNumber;

        // Reference to the Departments subcollection
        final departmentsCollection = FirebaseFirestore.instance
            .collection('Admins')
            .doc(userPhoneNumber)
            .collection('Departments');

        // Fetch all documents in Departments subcollection
        final querySnapshot = await departmentsCollection.get();

        // Extract the 'name' field from each document
        final departmentNames = querySnapshot.docs.map((doc) {
          return doc.data()['name'] as String? ?? 'Unnamed Department';
        }).toList();

        setState(() {
          departments = departmentNames;
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching departments: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchGroups() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userPhoneNumber = user.phoneNumber;

        // Reference to the Departments subcollection
        final groupsCollection = FirebaseFirestore.instance
            .collection('Admins')
            .doc(userPhoneNumber)
            .collection('Groups');

        // Fetch all documents in Departments subcollection
        final querySnapshot = await groupsCollection.get();

        // Extract the 'name' field from each document
        final Groupsnames = querySnapshot.docs.map((doc) {
          return doc.data()['description'] as String? ?? 'Unnamed Group';
        }).toList();

        setState(() {
          groups = Groupsnames;
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching departments: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      setState(() {
        _imageFiles.addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    } else {
      final XFile? pickedFile =
          await _picker.pickImage(source: source, imageQuality: 2);
      if (pickedFile != null) {
        setState(() {
          _imageFiles.add(File(pickedFile.path));
        });
      }
    }
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    String? userPhoneNumber = SharedPreferencesHelper.getString('adminNumber');

    for (int i = 0; i < images.length; i++) {
      try {
        String name = _name2Controller.text.toString().toLowerCase();
        String fileName = '$name${i + 1}.jpg';
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('Storage/$userPhoneNumber/Products/$fileName');
        UploadTask uploadTask = storageReference.putFile(images[i]);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return imageUrls;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedTextKit(repeatForever: true, animatedTexts: [
          TyperAnimatedText(
            speed: Durations.extralong1,
            'Add',
            // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TyperAnimatedText(
            'Product',
            // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ]
            // const Text('Add Product')
            ),
        // backgroundColor: Colors.blueAccent,
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
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
                    'Add a New Product',
                    style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16.0),
                _buildTextFormField(_productCodeController, 'Product Code',
                    'Please enter product code',
                    keyboardType: TextInputType.number),

                const SizedBox(height: 16.0),
                _buildTextFormField(
                    _productBarcodeController,
                    keyboardType: TextInputType.number,
                    'Product Barcode',
                    'Please enter product Barcode'),
                const SizedBox(height: 16.0),
                if (_showExtraFields)
                  Column(
                    children: [
                      _buildTextFormField(
                          _name2Controller, 'Name2', 'Enter Name 2'),
                      const SizedBox(height: 16.0),
                      _buildTextFormField(
                          _name3Controller, 'Name3', 'Enter Name 3'),
                      const SizedBox(height: 16.0),
                      _buildTextFormField(
                          _name4Controller, 'Name4', 'Enter Name 4'),
                      const SizedBox(height: 16.0),
                      _buildTextFormField(
                          _name5Controller, 'Name5', 'Enter Name 5'),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextFormField(
                        _productDescriptionController,
                        'Product Description',
                        'Please enter product description',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.list),
                      onPressed: _toggleFieldsVisibility,
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                Row(
                  children: [
                    Expanded(
                        child: _buildTextFormField(
                            _PriceController, 'Price', 'Enter Price',
                            keyboardType: TextInputType.number)),
                    const SizedBox(width: 8.0),
                    Expanded(
                        child: _buildTextFormField(
                            _CostController, 'Cost', 'Enter cost',
                            keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildTextFormField(_Price2Controller, 'Price 2', 'Price 2',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16.0),
                _buildTextFormField(_Price3Controller, 'Price 3', 'Price 3',
                    keyboardType: TextInputType.number),

                const SizedBox(height: 16.0),
                const Text('Price Control'),

                Column(
                  children: [
                    RadioListTile.adaptive(
                      title: const Text('Percent'),
                      value:
                          'Percent', // Set unique value for each RadioListTile
                      groupValue: _pricecontrol,
                      onChanged: (value) {
                        setState(() {
                          _pricecontrol = value!; // Update selected value
                        });
                      },
                    ),
                    RadioListTile.adaptive(
                      title: const Text('Open'),
                      value: 'Open',
                      groupValue: _pricecontrol,
                      onChanged: (value) {
                        setState(() {
                          _pricecontrol = value!;
                        });
                      },
                    ),
                    RadioListTile.adaptive(
                      title: const Text('Open, Zero Possible'),
                      value: 'OpenZero',
                      groupValue: _pricecontrol,
                      onChanged: (value) {
                        setState(() {
                          _pricecontrol = value!;
                        });
                      },
                    ),
                  ],
                ),

                CheckboxListTile.adaptive(
                  hoverColor: Colors.grey,
                  title: const Text('Stock'),
                  value: _isStockChecked,
                  onChanged: (value) {
                    setState(() {
                      _isStockChecked = value!; // Update the checkbox state
                    });
                  },
                ),
                if (_isStockChecked) ...[
                  SizedBox(height: 10),
                  _buildTextFormField(
                    _maxStockController,
                    'Stock',
                    'Enter Stock',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextFormField(
                    _minStockController,
                    'Safe Stock',
                    'Enter Safe Stock',
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Text('Department: '),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color:
                            Colors.grey[200], // Background color for dropdown
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedDepartment,
                        hint: const Text('Select Department'),
                        items: departments.isNotEmpty
                            ? departments.map((department) {
                                return DropdownMenuItem(
                                  value: department,
                                  child: Text(department),
                                );
                              }).toList()
                            : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                        underline: Container(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  color: const Color.fromARGB(
                      255, 216, 215, 215), // Set the background color to cream
                  padding: const EdgeInsets.all(8.0), // Add some padding
                  child: IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: _togglePromotionVisibility,
                  ),
                ),
                if (showPromotion)
                  Column(
                    children: [
                      // Title
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.grey,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Promotions',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // Tick Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isSingleItem,
                            onChanged: (bool? value) {
                              setState(() {
                                isSingleItem = value!;
                              });
                            },
                          ),
                          Text('Single Item'),
                          Checkbox(
                            value: isConsolidation,
                            onChanged: (bool? value) {
                              setState(() {
                                isConsolidation = value!;
                              });
                            },
                          ),
                          Text('Consolidation'),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Dropdown Menus with Labels
                      Row(
                        children: [
                          const Text('Groups: '),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: GroupValue,
                            hint: const Text('Select Group'),
                            items: groups.isNotEmpty
                                ? [
                                    ...groups.map((group) {
                                      return DropdownMenuItem(
                                        value: group,
                                        child: Text(group),
                                      );
                                    }).toList(),
                                    const DropdownMenuItem(
                                      value: "Same as Dept.",
                                      child: Text("Same as Dept."),
                                    ),
                                  ]
                                : null,
                            onChanged: onChangedHandlerGroup,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('KP: '),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: KPValue,
                            hint: const Text('Select KP'),
                            items: ["0-None", '#1', '#2', '#3', 'Same as Dept.']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: onChangedHandlerKP,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('VAT: '),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: VATValue,
                            hint: const Text('Select VAT'),
                            items: [
                              "0-None VAT",
                              '1-VAT1',
                              '2-VAT2',
                              '3-VAT3',
                              'Same as Dept.'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: onChangedHandlerGroupVAT,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('%: '),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: PercValue,
                            hint: const Text('Select %'),
                            items: ["Disable", "Enable", 'Same as Dept.']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: onChangedHandlerPercentage,
                          ),
                        ],
                      ),

                      // Radio Buttons
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type'),
                            RadioListTile<String>(
                              title: Text('Normal'),
                              value: 'Normal',
                              groupValue: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Division'),
                              value: 'Division',
                              groupValue: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Packet'),
                              value: 'Packet',
                              groupValue: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Menu (fixed)'),
                              value: 'Menu (fixed)',
                              groupValue: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text('Menu'),
                              value: 'Menu',
                              groupValue: selectedType,
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // Can be Condiment Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: canBeCondiment,
                            onChanged: (bool? value) {
                              setState(() {
                                canBeCondiment = value!;
                              });
                            },
                          ),
                          Text('Can be Condiment'),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Condiment Group Dropdown
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Text('Condiment Group'),
                            SizedBox(width: 10),
                            DropdownButton<String>(
                              items: <String>[
                                'Option 1',
                                'Option 2',
                                'Option 3'
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (_) {},
                              hint: Text('Select'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildImageButton(
                      context,
                      textTheme,
                      'Pick Images',
                      () => _pickImage(ImageSource.gallery),
                    ),
                    buildImageButton(
                      context,
                      textTheme,
                      'Take Picture',
                      () => _pickImage(ImageSource.camera),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (_imageFiles.isNotEmpty)
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 375),
                    child: FadeInAnimation(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _imageFiles.map((file) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: _submitForm,
                //   child: const Text('Submit'),
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomButton(
        context,
        textTheme,
        'Submit',
        _isLoading,
        () =>
            saveProductData(context), // Wrap in a lambda to pass as a callback
      ),
    );
  }

  Future<void> onChangedHandlerGroup(String? value) async {
    if (value == 'Same as Dept.') {
      // Fetch the department data and wait for the result
      selectDepart = await fetchDepartmentDataByName(
          _selectedDepartment!); // Replace with actual department name

      // Check if selectDepart has data and set _selectedGroup to the 'group' field
      if (selectDepart != null && selectDepart!.containsKey('group')) {
        setState(() {
          _selectedGroup = selectDepart!['group'] as String;
          GroupValue = value;
        });
        print('selectd group $_selectedGroup');
      } else {
        print("Group field not found in department data.");
      }
    } else {
      // If another option is selected, set _selectedGroup to that value
      setState(() {
        GroupValue = value;
        _selectedGroup = value;
      });
    }
  }

  Future<void> onChangedHandlerKP(String? value) async {
    if (value == 'Same as Dept.') {
      // Fetch the department data and wait for the result
      selectDepart = await fetchDepartmentDataByName(
          _selectedDepartment!); // Replace with actual department name

      // Check if selectDepart has data and set _selectedGroup to the 'group' field
      if (selectDepart != null && selectDepart!.containsKey('kp')) {
        setState(() {
          _selectedKP = selectDepart!['kp'].toString() as String;
          KPValue = value;
        });
        print('selectd group $_selectedKP');
      } else {
        print("Group field not found in department data.");
      }
    } else {
      // If another option is selected, set _selectedGroup to that value
      setState(() {
        KPValue = value;
        _selectedKP = value;
      });
    }
  }

  Future<void> onChangedHandlerGroupVAT(String? value) async {
    if (value == 'Same as Dept.') {
      // Fetch the department data and wait for the result
      selectDepart = await fetchDepartmentDataByName(
          _selectedDepartment!); // Replace with actual department name

      // Check if selectDepart has data and set _selectedGroup to the 'group' field
      if (selectDepart != null && selectDepart!.containsKey('vat')) {
        setState(() {
          _selectedVAT = selectDepart!['vat'] as String;
          VATValue = value;
        });
        print('selectd group $_selectedVAT');
      } else {
        print("Group field not found in department data.");
      }
    } else {
      // If another option is selected, set _selectedGroup to that value
      setState(() {
        VATValue = value;
        _selectedVAT = value;
      });
    }
  }

  Future<void> onChangedHandlerPercentage(String? value) async {
    if (value == 'Same as Dept.') {
      // Fetch the department data and wait for the result
      selectDepart = await fetchDepartmentDataByName(
          _selectedDepartment!); // Replace with actual department name

      // Check if selectDepart has data and set _selectedGroup to the 'group' field
      if (selectDepart != null && selectDepart!.containsKey('vatEnabled')) {
        setState(() {
          _selectedPerc = selectDepart!['vatEnabled'].toString() as String;
          PercValue = value;
        });
        print('selectd group $_selectedPerc');
      } else {
        print("Group field not found in department data.");
      }
    } else {
      // If another option is selected, set _selectedGroup to that value
      setState(() {
        PercValue = value;
        _selectedPerc = value;
      });
    }
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, String validatorText,
      {TextInputType keyboardType = TextInputType.text}) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 500),
      child: FadeInAnimation(
        duration: const Duration(milliseconds: 100),
        delay: const Duration(microseconds: 200),
        curve: Curves.easeInCubic,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
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

Future<Map<String, dynamic>> fetchDepartmentDataByName(String name) async {
  try {
    // Get current user's phone number
    final currentUser = FirebaseAuth.instance.currentUser;
    final phoneNumber = currentUser?.phoneNumber;

    if (phoneNumber == null) {
      throw Exception(
          "User is not authenticated or phone number is unavailable.");
    }

    // Reference to the specific document in the Departments sub-collection
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .doc(phoneNumber)
        .collection('Departments')
        .where('name', isEqualTo: name)
        .get();

    // Check if a matching document was found
    if (documentSnapshot.docs.isEmpty) {
      throw Exception("No department found with the name: $name");
    }

    // Get the first document's data and return it as a Map
    final departmentData = documentSnapshot.docs.first.data();
    return departmentData;
  } catch (e) {
    print("Error fetching department data: $e");
    return {}; // Return null if there's an error
}
}
