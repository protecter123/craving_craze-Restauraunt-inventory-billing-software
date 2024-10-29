import 'package:craving_craze/Utils/utils.dart';
import 'package:flutter/material.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            const Text('List of Customers'),
            // const Divider(),
            Gap.h(10),
            Table(
              border: TableBorder.all(color: m),
              children: const [
                TableRow(children: [
                  Center(
                    child: TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text('Customer Code')),
                  ),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Name')),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Balance Limit')),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Balance')),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Status')),
                ]),
                TableRow(children: [
                  Center(
                    child: TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Text('Customer Code')),
                  ),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Name')),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Balance Limit')),
                  TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Text('Balance')),
                  TableCell(child: Text('Status')),
                ]),
              ],
              //  columnWidths:const {
              //   0: Flexible(flex: 1),
              //   1: Flexible(flex: 3),
              //   2: Flexible(flex: 1),
              //   3: Flexible(flex: 1),
              //   4: Flexible(flex: 1),
              //  }
            ),
          ],
        ),
      ),
    );
  }
}

Widget tableCell(String text) {
  return Center(
    child: TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Text(text),
    ),
  );
}
