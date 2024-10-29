import 'package:flutter/material.dart';

class AccountMovementPage extends StatefulWidget {
  const AccountMovementPage({super.key});

  @override
  AccountMovementPageState createState() => AccountMovementPageState();
}

class AccountMovementPageState extends State<AccountMovementPage> {
  DateTimeRange? dateRange;
  TextEditingController searchController = TextEditingController();

  // Sample data for the table
  List<Map<String, String>> transactions = [
    {
      'code': '10/jzjt',
      'date': '12/09/2024 12:19',
      'type': 'Open account',
      'changed': '0.00',
      'balance': '0.00',
      'clerk': 'Owner'
    },
    {
      'code': '13/jfztjz',
      'date': '12/09/2024 12:23',
      'type': 'Withdraw',
      'changed': '-555.00',
      'balance': '5,000.55',
      'clerk': 'Owner'
    },
    // Add more sample data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Movement'),
      ),
      body: Column(
        children: [
          _buildDateRangePicker(),
          _buildSearchField(),
          Expanded(child: _buildDataTable()),
        ],
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDateRangePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildDateField('Start Date', dateRange?.start),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDateField('End Date', dateRange?.end),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                dateRange = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date) {
    return InkWell(
      onTap: () async {
        DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2025),
        );
        if (picked != null) {
          setState(() {
            dateRange = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(date != null
            ? '${date.day}/${date.month}/${date.year}'
            : 'Select Date'),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          //Todo Implement search logic here
        },
      ),
    );
  }

  Widget _buildDataTable() {
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
        rows: transactions.map((transaction) {
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
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.money_off), label: 'Withdraw'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Purchase List'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Account Movement'),
        BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Print'),
      ],
      currentIndex: 2, // Select Account Movement by default
      onTap: (index) {
        // Handle bottom navigation here
      },
    );
  }
}
