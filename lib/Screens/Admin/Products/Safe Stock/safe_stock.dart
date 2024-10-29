import 'package:flutter/material.dart';



class CustomerTablePage extends StatelessWidget {
  final List<Map<String, dynamic>> customerData = [
    {
      'code': 'C001',
      'Barcode': '1234',
      'Description': 1000,
      'Stock': 500,
      'Safe Stock': '100',
    },
    {
      'code': 'C002',
      'Barcode': '4567',
      'Description': 1500,
      'Stock': 300,
      'Safe Stock': '100',
    },
    // Add more customer data here
  ];

   CustomerTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Safe Stock'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Code')),
                DataColumn(label: Text('Barcode')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Stock')),
                DataColumn(label: Text('Safe Stock')),

              ],
              rows: customerData.map((customer) {
                return DataRow(cells: [
                  DataCell(Text(customer['code'])),
                  DataCell(Text(customer['Barcode'])),
                  DataCell(Text(customer['Description'].toString())),
                  DataCell(Text(customer['Stock'].toString())),
                  DataCell(Text(customer['Safe Stock'].toString())),


                ]);
              }).toList(),
            ),
            ),
        );
    }
}