import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  ProductManagementPageState createState() => ProductManagementPageState();
}

class ProductManagementPageState extends State<ProductManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _products = [];
  int _stockAdjustment = 0;
  String? _selectedProductId;
  String _adjustmentType = 'stockIn'; // Default adjustment type
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    QuerySnapshot snapshot =
        await _firestore.collection('/Admins/$adminNumber/Products').get();
    setState(() {
      _products = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    });
  }

  Future<void> _updateStocks(String productId) async {
    DocumentReference productRef =
        _firestore.collection('/Admins/$adminNumber/Products').doc(productId);
    DocumentSnapshot productSnapshot = await productRef.get();

    createCollectionsAndSubcollections();
    Map<String, dynamic> productData =
        productSnapshot.data() as Map<String, dynamic>;
    int currentStock = int.parse(productData['stocks'].toString());

    int updatedStock = 0;

    if (_adjustmentType == 'stockIn') {
      updatedStock = currentStock + _stockAdjustment;
    } else if (_adjustmentType == 'stockOut') {
      updatedStock = currentStock - _stockAdjustment;
    } else if (_adjustmentType == 'stockAdjustment') {
      updatedStock = _stockAdjustment;
    }

    await productRef.update({'stocks': updatedStock});

    // Add a new document in the Stocks subcollection
    await _firestore.collection('/Admins/$adminNumber/Stocks').add({
      'createdAt': Timestamp.now(),
      'productName': productData['name'],
      'type': _adjustmentType,
      'currentStock': currentStock,
      'updatedStocks': updatedStock,
    });

    // Reset input fields
    setState(() {
      _stockAdjustment = 0;
      _selectedProductId = null;
      _controller.clear();
    });

    // Reload products to reflect changes
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: DropdownButton<String>(
                itemHeight: kMinInteractiveDimension,
                alignment: AlignmentDirectional.center,
                isDense: true,
                // menuWidth: MediaQuery.of(context).size.width/1.5,
                focusColor: Colors.brown.shade100,
                isExpanded: false,
                padding: const EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(10),
                // menuWidth:300,
                hint: const Text('Select a Product'),
                value: _selectedProductId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProductId = newValue;
                  });
                },
                items: _products.map<DropdownMenuItem<String>>((product) {
                  return DropdownMenuItem<String>(
                    alignment: AlignmentDirectional.center,
                    value: product['id'],
                    child: Text(product['name']),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedProductId != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Current Stocks: ${_products.firstWhere((prod) => prod['id'] == _selectedProductId)['stocks']}'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Adjust Stock',

                      // hintText: 'eg. 1',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _stockAdjustment = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      RadioListTile<String>(
                        activeColor: Colors.black,
                        title: const Text('Stock In'),
                        value: 'stockIn',
                        groupValue: _adjustmentType,
                        onChanged: (String? value) {
                          setState(() {
                            _adjustmentType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: Colors.black,
                        title: const Text('Stock Out'),
                        value: 'stockOut',
                        groupValue: _adjustmentType,
                        onChanged: (String? value) {
                          setState(() {
                            _adjustmentType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        activeColor: Colors.black,
                        title: const Text('Adjust Stock'),
                        value: 'stockAdjustment',
                        groupValue: _adjustmentType,
                        onChanged: (String? value) {
                          setState(() {
                            _adjustmentType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _updateStocks(_selectedProductId!),
                    child: const Text('Update Stocks'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> createCollectionsAndSubcollections() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (int groupNum = 1; groupNum <= 2; groupNum++) {
    // Format the collection name as Group01, Group02, ..., Group60
    String groupName = groupNum.toString().padLeft(2, '0');
    String collectionName = 'Group$groupName';

    // Create the collection with the flag set to true
    await firestore.collection(collectionName).doc('GroupInfo').set({
      'flag': true,
    });

    // Loop to create 64 subcollections
    for (int subNum = 1; subNum <= 2; subNum++) {
      // Format the subcollection name as D001, D002, ..., D064
      String subName = subNum.toString().padLeft(3, '0');
      String subCollectionName = 'D$subName';

      // Create the subcollection with the required fields
      await firestore
          .collection(collectionName)
          .doc('GroupInfo')
          .collection(subCollectionName)
          .add({
        'code': subCollectionName,
        'show': true,
        'KP': 'none',
        'Group': collectionName,
        'type': true,
        'VAT': 'none',
        'percent': true,
        'reverse_calculation': false,
        'Enable_dept_Sale': false,
        'ticket_print_when_ticket_mode_active': true,
      });
    }
  }
  print('All collections and subcollections have been created.');
}
