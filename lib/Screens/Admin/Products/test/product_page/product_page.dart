import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Products",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
// Text('data'),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add Product Button
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Product"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(30, 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // primary: Colors.purple, // Button color
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildProductStats(context),
              const SizedBox(height: 20),
              _buildProductListHeader(),
              // _buildProductList(context),
            ],
          ),
        ),
      ),
    );
  }

  // Product Stats Section
  Widget _buildProductStats(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatsCard('Daily Sales', '35%', 'Total Products', Colors.purple,
            Colors.purple.shade100),
        _buildStatsCard('Daily Sales', '28%', 'New Products', Colors.orange,
            Colors.orange.shade100),
        _buildStatsCard('Daily Sales', '44%', 'Total Products', Colors.black,
            Colors.black12),
        _buildStatsCard('Daily Sales', '26%', 'Total Products',
            Colors.purpleAccent, Colors.purple.shade50),
      ],
    );
  }

  // Stats Card with gradient and better typography
  Widget _buildStatsCard(String title, String percentage, String subTitle,
      Color mainColor, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mainColor.withOpacity(0.2), mainColor.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          // SizedBox(height: 10),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          // Spacer(),
          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          // SizedBox(height: 5),
          // Text(
          //   amount,
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: mainColor,
          //   ),
          // ),
        ],
      ),
    );
  }

  // Product List Header with Search and Filter icons
  Widget _buildProductListHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Products List',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: Colors.grey[700]),
                onPressed: () {
                  // Search Action
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_alt_outlined, color: Colors.grey[700]),
                onPressed: () {
                  // Filter Action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Product List UI
  Widget _buildProductList(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var products = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            var product = products[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  // Product Card Widget with more prominent styling
  Widget _buildProductCard(DocumentSnapshot product) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(product['imageUrl'] ?? ''),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        title: Text(
          product['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          'Price: \$${product['price']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Edit product
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                // Delete product
              },
            ),
          ],
        ),
      ),
    );
  }
}
