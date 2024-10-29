import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'customer_provider.dart';

class AccountMovementPage1 extends StatelessWidget {
  const AccountMovementPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity:0,
        title: const Text('Account Movement'),
        centerTitle: true,

      ),
      body: Column(
        children: [
          _buildDateRangePicker(),
          _buildSearchField(),
          Expanded(child: _buildCustomerDataTable()),
        ],
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: _buildDateField('Start Date')),
          const SizedBox(width: 8),
          Expanded(child: _buildDateField('End Date')),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reset date range
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label) {
    return InkWell(
      onTap: () async {
        // Show date range picker logic here
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text('Select Date'),
      ),
    );
  }

  

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          // Update the customer list based on the search query
        },
      ),
    );
  }

  Widget _buildCustomerDataTable() {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        // if (provider.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return SingleChildScrollView(
          
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Changed Amount')),
              DataColumn(label: Text('Current Balance')),
              DataColumn(label: Text('Clerk')),
            ],
            rows: provider.transactions.map((transaction) {
              print('cakdjasflkaj');
              return DataRow(cells: [
                DataCell(Text(transaction['code'] ?? '')),
                DataCell(Text(transaction['date'] ?? '')),
                DataCell(Text(transaction['type'] ?? '')),
                DataCell(Text(transaction['changed'] ?? '')),
                DataCell(Text(transaction['balance'] ?? '')),
                DataCell(Text(transaction['clerk'] ?? '')),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
