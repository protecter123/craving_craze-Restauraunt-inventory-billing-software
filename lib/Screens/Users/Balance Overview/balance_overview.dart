// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BalanceOverviewPage extends StatefulWidget {
//   final String adminNumber = '+919999999999'; // Replace with your admin number
//   final String userNumber = '+916464646464';

//   const BalanceOverviewPage({super.key}); // Replace with your user number

//   @override
//   BalanceOverviewPageState createState() => BalanceOverviewPageState();
// }

// class BalanceOverviewPageState extends State<BalanceOverviewPage> {
//   DateTime? startDate;
//   DateTime? endDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Balance Overview'),
//       ),
//       body: Column(
//         children: [
//           _buildDatePicker(),
//           Expanded(
//             child: StreamBuilder<List<QueryDocumentSnapshot>>(
//               stream: _getBalanceHistoryStream(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     return const Center(child: CircularProgressIndicator());
//                   default:
//                     if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                       return _buildBalanceOverview(snapshot.data!);
//                     } else {
//                       return const Center(child: Text('No data available'));
//                     }
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDatePicker() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Column(
//             children: [
//               const Text('Start Date:'),
//               TextButton(
//                 onPressed: () => _selectDate(true),
//                 child: Text(startDate != null ? DateFormat.yMd().add_jm().format(startDate!) : 'Select Date'),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               const Text('End Date:'),
//               TextButton(
//                 onPressed: () => _selectDate(false),
//                 child: Text(endDate != null ? DateFormat.yMd().add_jm().format(endDate!) : 'Select Date'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(bool isStartDate) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != (isStartDate ? startDate : endDate)) {
//       setState(() {
//         if (isStartDate) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   Stream<List<QueryDocumentSnapshot>> _getBalanceHistoryStream() async* {
//     if (startDate == null || endDate == null) {
//       yield [];
//       return;
//     }

//     final balanceCollection = FirebaseFirestore.instance
//         .collection('Admins')
//         .doc(widget.adminNumber)
//         .collection('Customers')
//         .doc(widget.userNumber)
//         .collection('Balance');

//     yield* balanceCollection
//         .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
//         .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate!))
//         .snapshots()
//         .map((snapshot) => snapshot.docs);
//   }

//   Widget _buildBalanceOverview(List<QueryDocumentSnapshot> balanceHistoryDocs) {
//     final balanceHistory = balanceHistoryDocs.map((doc) => BalanceHistory.fromMap(doc.data() as Map<String, dynamic>)).toList();

//     // Calculate totals
//     double totalTopUps = balanceHistory.where((h) => h.type == 'topUp').fold(0, (sums, h) => sums + (h.changedAmount ?? 0));
//     double totalWithdrawals = balanceHistory.where((h) => h.type == 'withdrawal').fold(0, (sums, h) => sums + (h.changedAmount ?? 0));

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columnSpacing: 8,
//         columns: const [
//           DataColumn(label: Text('Date')),
//           DataColumn(label: Text('Type')),
//           DataColumn(label: Text('Changed Amount')),
//           DataColumn(label: Text('Current Amount')),
//           DataColumn(label: Text('User ID')),
//           DataColumn(label: Text('Changed By')),
//         ],
//         rows: balanceHistory.map((history) {
//           return DataRow(cells: [
//             DataCell(Text(DateFormat.yMd().add_jm().format(history.date!))),
//             DataCell(Text(history.type ?? '')),
//             DataCell(Text('${history.changedAmount ?? 0}')),
//             DataCell(Text('${history.balance ?? 0}')),
//             DataCell(Text(history.userId ?? '')),
//             DataCell(Text(history.changedBy == 'admin' ? 'Admin' : 'User')),
//           ]);
//         }).toList()
//           ..add(DataRow(cells: [
//             const DataCell(Text('Total')),
//             const DataCell(Text('TopUps')),
//             DataCell(Text('$totalTopUps')),
//             const DataCell(Text('')),
//             const DataCell(Text('')),
//             const DataCell(Text('')),
//           ]))..add(DataRow(cells: [
//              const DataCell(Text('Total')),
//             const DataCell(Text('Withdrawals')),
//             DataCell(Text('-$totalWithdrawals')),
//             const DataCell(Text('')),
//             const DataCell(Text('')),
//             const DataCell(Text('')),
//           ]))
//       ),
//     );
//   }
// }

// class BalanceHistory {
//   final String? code;
//   final DateTime? date;
//   final String? userId; // Assuming this is the createdBy field
//   final double? amount;
//   final String? type;
//   final double? changedAmount; // Add this field if needed
//   final double? balance; // Add this field if needed
//   final String? changedBy; // Add this field to indicate who made the change

//   BalanceHistory({this.code, this.date, this.userId, this.amount, this.type, this.changedAmount, this.balance, this.changedBy});

//   factory BalanceHistory.fromMap(Map<String, dynamic> map) {
//     return BalanceHistory(
//       code: map['code'],
//       date: (map['date'] as Timestamp?)?.toDate(), // Convert Firestore Timestamp to DateTime
//       userId: map['createdBy'], // Assuming this is the field name for createdBy
//       amount: map['amount']?.toDouble(), // Ensure amount is a double
//       type: map['type'],
//       changedAmount: map['changedAmount']?.toDouble(), // Ensure changedAmount is a double
//       balance: map['balance']?.toDouble(), // Ensure balance is a double
//       changedBy: map['changedBy'], // Assuming this field indicates who made the change
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceOverviewPage extends StatefulWidget {
  final String adminNumber = '+919999999999'; // Replace with your admin number

  const BalanceOverviewPage({super.key});

  @override
  BalanceOverviewPageState createState() => BalanceOverviewPageState();
}

class BalanceOverviewPageState extends State<BalanceOverviewPage> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Overview'),
      ),
      body: Column(
        children: [
          _buildDatePicker(),
          Expanded(
            child: StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: _getBalanceHistoryStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return _buildBalanceOverview(snapshot.data!);
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Text('Start Date:'),
              TextButton(
                onPressed: () => _selectDate(true),
                child: Text(startDate != null
                    ? DateFormat.yMd().format(startDate!)
                    : 'Select Date'),
              ),
            ],
          ),
          Column(
            children: [
              const Text('End Date:'),
              TextButton(
                onPressed: () => _selectDate(false),
                child: Text(endDate != null
                    ? DateFormat.yMd().format(endDate!)
                    : 'Select Date'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (startDate ?? DateTime.now())
          : (endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // Stream<List<QueryDocumentSnapshot>> _getBalanceHistoryStream() async* {
  //   if (startDate == null || endDate == null) {
  //     yield [];
  //     return;
  //   }

  //   // Reference to all customers under the "Customers" collection
  //   final customersCollection = FirebaseFirestore.instance
  //       .collection('Admins')
  //       .doc(widget.adminNumber)
  //       .collection('Customers');

  //   // Get balance history for all customers in the specified date range
  //   yield* customersCollection.snapshots().asyncExpand((customersSnapshot) async* {
  //     List<QueryDocumentSnapshot> allBalanceHistoryDocs = [];

  //     for (var customer in customersSnapshot.docs) {
  //       final balanceCollection = customer.reference.collection('Balance');

  //       // Fetch balance documents within the specified date range
  //       final balanceDocs = await balanceCollection
  //           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!))
  //           // .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate!))
  //           .get();

  //       allBalanceHistoryDocs.addAll(balanceDocs.docs);
  //     }

  //     yield allBalanceHistoryDocs;
  //   });
  // }

  Stream<List<QueryDocumentSnapshot>> _getBalanceHistoryStream() async* {
    if (startDate == null || endDate == null) {
      yield [];
      return;
    }
// if (startDate == null || endDate == null) {
    DateTime startOfDay =
        DateTime(startDate!.year, startDate!.month, startDate!.day);
    DateTime endOfDay =
        DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
    final customersCollection = FirebaseFirestore.instance
        .collection('Admins')
        .doc(widget.adminNumber)
        .collection('Customers');

    // Fetch all customer documents concurrently using Future.wait
    final customersSnapshot = await customersCollection.get();

    // Use Future.wait to fetch each customer's balance collection concurrently
    List<QueryDocumentSnapshot> allBalanceDocs = await Future.wait(
      customersSnapshot.docs.map((customerDoc) async {
        final balanceCollection = customerDoc.reference.collection('Balance');

        // Fetch balance history for each customer based on date range
        final balanceSnapshot = await balanceCollection
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
            .get();

        return balanceSnapshot.docs;
      }).toList(),
    ).then((results) => results.expand((docs) => docs).toList());

    yield allBalanceDocs;
  }

  Widget _buildBalanceOverview(List<QueryDocumentSnapshot> balanceHistoryDocs) {
    final balanceHistory = balanceHistoryDocs
        .map(
            (doc) => BalanceHistory.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    // Calculate totals
    double totalTopUps = balanceHistory
        .where((h) => h.type == 'topUp')
        .fold(0, (sums, h) => sums + (h.changedAmount ?? 0));
    double totalWithdrawals = balanceHistory
        .where((h) => h.type == 'withdrawal')
        .fold(0, (sums, h) => sums + (h.changedAmount ?? 0));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columnSpacing: 8,
          columns: const [
            DataColumn(label: Text('Code')),
            // DataColumn(label: Text('Name')),

            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Changed Amount')),
            DataColumn(label: Text('Current Amount')),
            // DataColumn(label: Text('User ID')),
            DataColumn(label: Text('Changed By')),
          ],
          rows: balanceHistory.map((history) {
            return DataRow(cells: [
              DataCell(Text(history.code ?? '')),
              // DataCell(Text(history.name?? '')), // Assuming userId is stored in the userId field
              DataCell(Text(DateFormat.yMd().add_jm().format(history.date!))),
              DataCell(Text(history.type.toString().toUpperCase())),
              DataCell(Text('${history.changedAmount ?? 0}')),
              DataCell(Text('${history.balance ?? 0}')),
              // DataCell(Text(history.userId ?? '')),
              DataCell(Text(history.changedBy == 'admin' ? 'Admin' : 'User')),
            ]);
          }).toList()
            ..add(DataRow(cells: [
              const DataCell(
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(Text('TopUps',
                  style: TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text('$totalTopUps')),
              // const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ]))
            ..add(DataRow(cells: [
              const DataCell(Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              const DataCell(Text(
                'Withdrawals',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              DataCell(Text('-$totalWithdrawals')),
              // const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ]))),
    );
  }
}

class BalanceHistory {
  final String? code;
  final String? name;
  final DateTime? date;
  final String? userId;
  final double? amount;
  final String? type;
  final double? changedAmount;
  final double? balance;
  final String? changedBy;

  BalanceHistory({
    this.name,
    this.code,
    this.date,
    this.userId,
    this.amount,
    this.type,
    this.changedAmount,
    this.balance,
    this.changedBy,
  });

  factory BalanceHistory.fromMap(Map<String, dynamic> map) {
    return BalanceHistory(
      name: map['name'],
      code: map['code'].toString(),
      date: (map['date'] as Timestamp?)?.toDate(),
      userId: map['createdBy'],
      amount: map['amount']?.toDouble(),
      type: map['type'],
      changedAmount: map['changedAmount']?.toDouble(),
      balance: map['balance']?.toDouble(),
      changedBy: map['changedBy'],
    );
  }
}
