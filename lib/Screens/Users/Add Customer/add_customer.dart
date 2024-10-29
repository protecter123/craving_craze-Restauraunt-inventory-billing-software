import 'package:flutter/material.dart';

import '../../../Widgets/widgets.dart';

class AddCustomer extends StatefulWidget {
  final int? customer;
  const AddCustomer({super.key, this.customer});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  @override
  Widget build(BuildContext context) {
    int? c = widget.customer;
    int? code = c != null ? c + 1 : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Code: '),
                Text(code.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            // buildTextFormField(labelText: 'Code',readOnly: true),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            Checkbox.adaptive(value: true, onChanged: (b) {}),
            const Text('Balance'),
            buildTextFormField(labelText: 'Balance'),
            const Text('Balance Limit'),
            buildTextFormField(labelText: 'Balance Limit'),
            const Text('Price Control'),
            Radio(value: true, groupValue: 'Level 1', onChanged: (b) {}),
            const Text('Auto Discount'),
            buildTextFormField(
                labelText: 'Auto Discount', sIcon: const Text('%')),
            const Text('GSTIN'),
            const Text('Address'),
            buildTextFormField(labelText: 'Address', readOnly: true),
            const TextField(
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add customer logic here
                // Scaffold.of(context).showSnackBar( SnackBar(content: Text('Customer added successfully')));
              },
              child: const Text('Add Customer'),
            ),

            const Text('or'),
            ElevatedButton(
              onPressed: () {
                // Cancel or go back to previous screen
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            const SizedBox(height: 20), // Add some spacing between buttons
          ],
        ),
      ),
    );
  }
}
