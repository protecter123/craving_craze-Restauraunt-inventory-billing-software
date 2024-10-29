import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  BalancePageState createState() => BalancePageState();
}

class BalancePageState extends State<BalancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Balances'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('/Admins/+919999999999/Customers')
            .orderBy('code', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No customers found'));
          }

          // Initialize total balance
          double totalBalance = 0.0;

          // Loop through each customer and sum the balances
          List<DataRow> rows = [];
          for (var doc in snapshot.data!.docs) {
            double balance =
                doc['balance'] ?? 0.0; // Ensure balance is not null
            totalBalance += balance;
            final bool isActive = doc['is_active'];
            // Add rows for DataTable
            rows.add(
              DataRow(cells: [
                DataCell(Text(doc['code'].toString())),
                DataCell(Text(doc['name'] ?? 'Unknown')),
                DataCell(Text('₹${balance.toStringAsFixed(2)}')),
                DataCell(Text(isActive ? 'Active' : ' Inactive'))
              ]),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Balance of All Customers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '₹${totalBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: MediaQuery.of(context).size.width / 8.65,
                        checkboxHorizontalMargin: 1,
                        columns: const [
                          DataColumn(label: Text('Code')),
                          DataColumn(
                            label: Text('Customer Name'),
                          ),
                          DataColumn(
                            label: Text('Balance'),
                          ),
                          DataColumn(
                            label: Text('Status'),
                          ),
                        ],
                        rows: rows, // Rows generated from the loop above
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
