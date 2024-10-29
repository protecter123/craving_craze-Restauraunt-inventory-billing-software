import 'package:craving_craze/Screens/Admin/Registration/Table/table_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableInfo extends StatelessWidget {
  const TableInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final tableInfo = Provider.of<TableInfoProvider>(context);
    // String type = tableInfo.setDiningType('Take Away');
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Table Info')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildButton(tableInfo.cgstLabel, () {
              tableInfo.toggleCgst();
            }, Colors.blue),
            // Use diningType from the provider to dynamically update the button label
            _buildButton(tableInfo.diningType, () {
              // You can add any logic if needed here.
            }, Colors.orange),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconButton(Icons.restaurant, () {
                  tableInfo.setDiningType('Dine In');
                }),
                _buildIconButton(Icons.shopping_bag, () {
                  tableInfo.setDiningType('Take Away');
                }),
                _buildIconButton(Icons.delivery_dining, () {
                  tableInfo.setDiningType('Delivery');
                }),
              ],
            ),
            SizedBox(height: 10),
            Text('Clerk: Owner'),
            InkWell(
              onTap: () => _showPersonDialog(context, tableInfo),
              child: Text(
                  'Table no:<${tableInfo.tableNo}> ${tableInfo.personCount}P'),
            ),
            Text(tableInfo.currentDateTime),
            Divider(),
            _buildTotalsSection(),
            Spacer(),
            _buildFooter(),
          ],
        ),
      ),
    ));
  }

  // Button widget
  Widget _buildButton(String label, VoidCallback onPressed, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(label),
      ),
    );
  }

  // Icon button widget
  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 40),
      onPressed: onPressed,
    );
  }

  // Totals section (static for now)
  Widget _buildTotalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTotalRow('Subtotal', '0.00'),
        _buildTotalRow('CGST', '0.00'),
        _buildTotalRow('SGST', '0.00'),
        _buildTotalRow('Items', '0.00'),
        _buildTotalRow('TOTAL', '0.00'),
      ],
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  // Footer section
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: Icon(Icons.exit_to_app), onPressed: () {}),
        IconButton(icon: Icon(Icons.print), onPressed: () {}),
        IconButton(icon: Icon(Icons.lock), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  // Show dialog to update person count
  Future<void> _showPersonDialog(
      BuildContext context, TableInfoProvider tableInfo) async {
    final TextEditingController personController =
        TextEditingController(text: tableInfo.personCount.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Person Count'),
        content: TextField(
          controller: personController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Enter number of persons'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final int newPersonCount =
                  int.tryParse(personController.text) ?? tableInfo.personCount;
              tableInfo.updatePersonCount(newPersonCount);
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
