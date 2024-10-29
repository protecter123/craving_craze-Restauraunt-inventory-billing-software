import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dataprovider.dart';


class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Brands')),
      body: FutureBuilder(
        future: dataProvider.loadCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Consumer<DataProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.customers.length,
                  itemBuilder: (context, index) {
                    final brand = provider.customers[index];
                    return SingleChildScrollView(
          
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Code')),
              // DataColumn(label: Text('Date')),
              DataColumn(label: Text('Type')),
              // DataColumn(label: Text('Changed Amount')),
              // DataColumn(label: Text('Current Balance')),
              // DataColumn(label: Text('Clerk')),
            ],
            rows: [
               DataRow(cells: [
                DataCell(Text(brand.code.toString())),
                
                DataCell(Text(brand.name)),
                // DataCell(Text(brand['type'] ?? '')),
                // DataCell(Text(brand['changed'] ?? '')),
                // DataCell(Text(brand['balance'] ?? '')),
                // DataCell(Text(brand['clerk'] ?? '')),
              ])
            ]
          ),
        );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
