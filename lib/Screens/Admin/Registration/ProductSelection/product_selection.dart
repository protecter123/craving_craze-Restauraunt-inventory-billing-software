import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductSelection extends StatefulWidget {
  const ProductSelection({Key? key}) : super(key: key);

  @override
  _ProductSelectionState createState() => _ProductSelectionState();
}

class _ProductSelectionState extends State<ProductSelection> {
  late Future<List<Map<String, dynamic>>> _departmentsFuture;
  Map<String, Future<List<Map<String, dynamic>>>> _productsFutureMap = {};

  @override
  void initState() {
    super.initState();
    _departmentsFuture = _fetchDepartments();
  }

  // Fetch departments data from Firebase
  Future<List<Map<String, dynamic>>> _fetchDepartments() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final phoneNumber = currentUser?.phoneNumber;

    if (phoneNumber == null) {
      throw Exception(
          "User is not authenticated or phone number is unavailable.");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .doc(phoneNumber)
        .collection('Departments')
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Fetch products for a specific department name
  Future<List<Map<String, dynamic>>> _fetchProducts(
      String departmentName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final phoneNumber = currentUser?.phoneNumber;

    if (phoneNumber == null) {
      throw Exception(
          "User is not authenticated or phone number is unavailable.");
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .doc(phoneNumber)
        .collection('Products')
        .where('selectedDepartment', isEqualTo: departmentName)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display department buttons at the top
        FutureBuilder<List<Map<String, dynamic>>>(
          future: _departmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No departments available"));
            }

            final departments = snapshot.data!;
            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: 6,
              childAspectRatio: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              padding: const EdgeInsets.all(8),
              children: departments.map((dept) {
                return buildButton(
                  context,
                  dept['code'], // Display 'code' field as button label
                  () {
                    setState(() {
                      _productsFutureMap[dept['name']] = _fetchProducts(dept[
                          'name']); // Fetch products for selected department
                    });
                  },
                  color: Colors.blueAccent,
                );
              }).toList(),
            );
          },
        ),

        // Display product buttons below the department buttons
        Expanded(
          child: ListView(
            children: _productsFutureMap.entries.map((entry) {
              return FutureBuilder<List<Map<String, dynamic>>>(
                future: entry.value,
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productSnapshot.hasError) {
                    return Center(
                        child: Text("Error: ${productSnapshot.error}"));
                  } else if (!productSnapshot.hasData ||
                      productSnapshot.data!.isEmpty) {
                    return Container(); // No products for this department
                  }

                  final products = productSnapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Products in ${entry.key}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 6,
                        childAspectRatio: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        padding: const EdgeInsets.all(8),
                        physics: const NeverScrollableScrollPhysics(),
                        children: products.map((product) {
                          return buildButton(
                            context,
                            product[
                                'name'], // Display 'name' field as button label
                            () {
                              // Define what happens when a product button is tapped, if needed
                            },
                            color: Colors.greenAccent,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

Widget buildButton(BuildContext context, String label, VoidCallback onPressed,
    {Color color = Colors.grey,
    double height = double.infinity,
    double width = double.infinity,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0)}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: padding,
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
      ),
    ),
  );
}