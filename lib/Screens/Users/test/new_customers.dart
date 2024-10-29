import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  CustomerPageState createState() => CustomerPageState();
}

class CustomerPageState extends State<CustomerPage> {
  final TextEditingController _searchController = TextEditingController();
  int pageSize = 10;
  double _inputAmount = 0.0;

  Stream<QuerySnapshot> _getCustomerStream() {
    return FirebaseFirestore.instance
        .collection('Admins')
        .doc(adminNumber)
        .collection('Customers')
        .orderBy('code')
        .snapshots();
  }

  void _handleRowTap(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final int code = int.parse(data['code'].toString());
    final String name = data['name'];
    final double currentBalance = data['balance'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Update Balance for $name (Code: $code)',
            style: textTheme.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Balance: $currentBalance',
                  style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _inputAmount = double.tryParse(value) ?? 0.0;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _updateBalance(document, _inputAmount, true);
                  Navigator.pop(context);
                },
                child: const Text('Top-Up Balance'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateBalance(document, _inputAmount, false);
                  Navigator.pop(context);
                },
                child: const Text('Withdraw Balance'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateBalance(
      DocumentSnapshot document, double amount, bool topUp) async {
    final data = document.data() as Map<String, dynamic>;
    final double currentBalance = data['balance'];
    double updatedBalance =
        topUp ? currentBalance + amount : currentBalance - amount;
    await document.reference.update({'balance': updatedBalance});
  }

  void _loadMoreCustomers() {
    setState(() {
      pageSize += 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by code, name, mobile, or email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getCustomerStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No customers found.'));
          }

          final documents = snapshot.data!.docs;

          return SingleChildScrollView(
            child: PaginatedDataTable(
              // header: const Text('Customers'),
              columns: const [
                DataColumn(label: Text('Code')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Balance')),
                DataColumn(label: Text('Balance Limit')),
                DataColumn(label: Text('Status')),
              ],
              source: _CustomerDataSource(
                documents: documents,
                onRowTap: _handleRowTap,
              ),
              rowsPerPage: pageSize,
              onPageChanged: (value) => _loadMoreCustomers(),
            ),
          );
        },
      ),
    );
  }
}

class _CustomerDataSource extends DataTableSource {
  final List<DocumentSnapshot> documents;
  final Function(DocumentSnapshot) onRowTap;

  _CustomerDataSource({required this.documents, required this.onRowTap});

  @override
  DataRow getRow(int index) {
    final document = documents[index];
    final data = document.data() as Map<String, dynamic>;
    final bool isActive = data['is_active'];

    return DataRow(
      cells: [
        DataCell(Text(data['code'].toString())),
        DataCell(Text(data['name'])),
        DataCell(Text(data['balance'].toString())),
        DataCell(Text(data['balance_limit'].toString())),
        DataCell(Row(
          children: [
            isActive
                ? const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  )
                : const Icon(Icons.check_box_outline_blank, color: Colors.red),
            isActive ? const Text('Active') : const Text('Inactive')
          ],
        )),
      ],
      onSelectChanged: (_) {
        onRowTap(document);
      },
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => documents.length;

  @override
  int get selectedRowCount => 0;
}
