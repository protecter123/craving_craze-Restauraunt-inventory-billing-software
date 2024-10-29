import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:craving_craze/Utils/Global/global.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_products.dart';
import 'test/add_products.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String? number = SharedPreferencesHelper.getString('adminNumber');
  // final _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  int _productsLimit = 10; // Pagination limit
  String _searchQuery = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    // Scroll listener for loading more products on scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreProducts();
      }
    });
  }

  // Function to increase the product limit for pagination
  void _loadMoreProducts() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
        _productsLimit += 10; // Increase the limit by 10
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              // Container(
              //     width: MediaQuery.of(context).size.width*6, // take up full width
              //     child: AutoScrollingText(),

              const Text('Products')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Gap.h(10),
            TextField(
              // controller:_searchController,
              onChanged: (value) {
                _searchQuery = value.toLowerCase();
              },
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Admins')
                    .doc(number)
                    .collection('Products')
                    .where('deleted', isEqualTo: false)
                    .limit(_productsLimit)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: m,
                    ));
                  }

                  if (snapshot.data == null) {
                    return const Center(child: Text('No data available'));
                  }

                  final products = snapshot.data!.docs;

                  // If the search query is not empty, filter products
                  // final searchQuery =_searchController.text;
                  final filteredProducts = _searchQuery.isNotEmpty
                      ? products.where((product) {
                          final name = product['name']?.toLowerCase() ?? '';
                          final category =
                              product['category']?.toLowerCase() ?? '';
                          final subcategory =
                              product['subcategory']?.toLowerCase() ?? '';
                          final productCode = product['productCode'] != null
                              ? product['productCode']
                                  .toString() // Convert int to string
                              : '';

                          return name.contains(_searchQuery) ||
                              category.contains(_searchQuery) ||
                              subcategory.contains(_searchQuery) ||
                              productCode.contains(_searchQuery);
                        }).toList()
                      : products
                          .take(_productsLimit)
                          .toList(); // Pagination handling for initial products

                  return ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.vertical,
                      reverse: false, // Show products in descending order
                      controller: _scrollController,
                      itemCount:
                          filteredProducts.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show loading indicator while fetching more products
                        if (index == filteredProducts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // Product data
                        final product = filteredProducts[index];
                        return Card(
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(product['images'][0],
                                    width: 50, height: 50, fit: BoxFit.cover)),
                            title: Text(product['name'] ?? ''),
                            subtitle: Text(product['description'] ?? ''),
                            trailing: Wrap(
                              children: [
                                // Lottie.asset('assets/animatios/jk.json'),
                                IconButton(
                                    onPressed: () {
                                      String subCategory =
                                          product['subcategory'] ?? '';
                                      String brand = product['brand'] ?? '';
                                      String category =
                                          product['category'] ?? '';
                                      editProduct(context, product.id,
                                          subCategory, category, brand);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () => deleteProduct(
                                        context, product, number!),
                                    icon: const Icon(Icons.delete_forever)),
                              ],
                            ),
                            onTap: () => _showOrderDetails(context, product),
                          ),
                        );
                      });
                },
              ),
            ),
            // AutoScrollingText()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => push(context, AddProductPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> deleteProduct(
    BuildContext context, DocumentSnapshot product, String number) async {
  try {
    await FirebaseFirestore.instance
        .collection('Admins')
        .doc(number)
        .collection('Products')
        .doc(product.id)
        .update({'deleted': true});

    // Show confirmation message
    context.mounted
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          )
        : null;
  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Error deleting product: $e')),
    // );
    print('Error deleting product: $e');
  }
}

void editProduct(BuildContext context, String productId, String subCategory,
    String category, String brand) {
  // Navigate to the product editing page with pre-filled data
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddProductPage1(
        productId: productId,
        // subcategory: subCategory,
        // category: category,
        // brand: brand,
        // productData: product.data() as Map<String, dynamic>, // Pass the product data
        // isEditMode: true, // Indicate edit mode
        // productId: product.id, // Pass the product ID
      ),
    ),
  );
}

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void _showOrderDetails(
    BuildContext context, QueryDocumentSnapshot<Map<String, dynamic>> product) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentTextStyle: textTheme.bodyMedium,
        title: Center(
            child: Text(
          'Product Details',
          style: GoogleFonts.ptSans(color: Colors.black),
        )),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              //         'name': productName,
              //   'description': productDescription,
              //   'mrp': mrp,
              //   'salePrice': salePrice,
              //   'wholesalePrice': wholesalePrice,
              //   'discountedPrice': discountedPrice,
              //   'images': imageUrls,
              //   'createdAt': Timestamp.now(),
              //   'isActive': false,
              //   'minStock': minStock,
              //   'quantity':quantity,
              //   'category': widget.category,
              //  'subcategory': widget.subcategory,
              //  'brand': widget.brand,
              //  'maxStock': maxStock,
              //   'units': units,
              //  'stocks': stocks,
              //   'dealerPrice': dealerPrice,
              //  'manufactur': manufactur,
              //  'productCode':productCode,
              // Text('Order ID: ${product['orderId'] ?? ''}'),
              Text('Product Name: ${product['name'] ?? ''}'),
              Text('Description: ${product['description'] ?? ''}'),
              Text('Price: ${product['price'] ?? ''}'),
              //Text('Stocks: ${product['stocks'] ?? ''}'),
              //Text('Quantity: ${product['quantity'] ?? ''}'),
              Text('ProductCode: ${product['productCode'] ?? ''}'),
              // Text(': ${_formatTimestamp(product['orderTime'])}'),
              // // Text('Accepted At: ${_formatTimestamp(product['acceptedAt'])}'),
              // Text('Quantity: ${product['quantity'] ?? ''}'),
              // Text('Total Price: ${product['totalPrice'] ?? ''}'),
              // // Text('Completed: ${order['completed'] ?? ''}'),
              // // Text('Delivered: ${order['delivered'] ?? ''}'),
              // Text('Returned: ${order['returned'] ?? ''}'),
              // Text('Pending: ${order['pending'] ?? ''}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Close',
              style: GoogleFonts.ptSans(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // TextButton(onPressed: (){},
          // child: Text('Edit'))
        ],
      );
    },
  );
}

String _formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return 'N/A';
  return timestamp.toDate().toString();
}
