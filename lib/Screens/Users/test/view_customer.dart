import 'package:craving_craze/Screens/Users/test/add_c_t.dart';
import 'package:craving_craze/Utils/Global/global.dart';
import 'package:craving_craze/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  CustomerListPageState createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  String? adminNumber = SharedPreferencesHelper.getString('adminNumber'),
      userNumber = SharedPreferencesHelper.getString('userNumber');
  final TextEditingController _searchController = TextEditingController();
  var searchQuery;

  int pageSize = 20;
  DocumentSnapshot? lastDocument;
  bool isLoading = false;
  bool hasMoreData = true;
  List<DocumentSnapshot> customers = [];
  int customersCount = 0;
  double _inputAmount = 0.0;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    _loadInitialCustomers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  Future<void> _loadInitialCustomers() async {
    if (!isLoading) {
      setState(() => isLoading = true);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(adminNumber)
          .collection('Customers')
          .orderBy('code', descending: true)
          .limit(pageSize)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        customers = querySnapshot.docs;
      } else {
        hasMoreData = false;
      }

      setState(() => isLoading = false);
    }
  }

  Future<void> _loadMoreCustomers() async {
    if (!isLoading && hasMoreData) {
      setState(() => isLoading = true);

      // Log that pagination is triggered
      print('Loading more customers...');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(adminNumber)
          .collection('Customers')
          .orderBy('code', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(pageSize)
          .get();

      // for (var doc in querySnapshot.docs) {
      //   print('Customer Code: ${doc['code']}, Name: ${doc['name']}, Balance: ${doc['balance']}, Limit: ${doc['balanceLimit']}');
      // }

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        customers.addAll(querySnapshot.docs);

        print(
            'Loaded ${querySnapshot.docs.length} more customers. Total: ${customers.length}');

        // for (var doc in querySnapshot.docs) {
        //   print('Customer Code: ${doc['code']}, Name: ${doc['name']}, Balance: ${doc['balance']}, Limit: ${doc['balanceLimit']}');
        // }
      } else {
        hasMoreData = false;

        print('No more customers to load.');
      }

      setState(() => isLoading = false);
    } else if (isLoading) {
      print('Already loading...');
    } else if (!hasMoreData) {
      print('No more data to load.');
    }
  }

  // Stream<QuerySnapshot> _getCustomerStream() {

  //   Query query = FirebaseFirestore.instance.collection('Admins')
  //   .doc(adminNumber).collection('Users').doc(userNumber).collection('Customers');

  //   if (searchQuery.isNotEmpty) {
  //     query = query.where('code', isEqualTo: searchQuery)
  //       .where('name', isEqualTo: searchQuery)
  //       .where('mobile', isEqualTo: searchQuery)
  //       .where('email', isEqualTo: searchQuery);
  //   }

  //   return query.snapshots();
  // }

  Stream<QuerySnapshot> _getCustomerStream() {
    CollectionReference customersRef = FirebaseFirestore.instance
        .collection('Admins')
        .doc(adminNumber)
        .collection('Customers');

    // if (searchQuery.isNotEmpty) {
    //   // You can modify the filtering logic according to your exact query needs
    //   return customersRef
    //       // .where('code', isEqualTo: searchQuery)
    //       .where('name', isEqualTo: searchQuery)
    //     // .where('mobile', isEqualTo: searchQuery)
    //     // .where('email', isEqualTo: searchQuery)
    //       .snapshots();
    // }

    return customersRef.orderBy('code', descending: true).snapshots();
  }

  void _editCustomer(DocumentSnapshot customer, int counts) async {
    // Navigate to Add/Edit customer page with pre-filled customer data
    final bool? customerUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddC(
                customerData: customer,
                counts: counts,
              )),
    );

    if (customerUpdated == true) {
      // Reload customers if a customer was updated
      _loadInitialCustomers();
    }
  }

  void _deleteCustomer(DocumentSnapshot customer) async {
    // Show confirmation dialog before deleting
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Customer',
          style: textTheme.headlineSmall,
        ),
        content: Text('Are you sure you want to delete this customer?',
            style: textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      // Delete customer document from Firestore
      await FirebaseFirestore.instance
          .collection('Admins')
          .doc(adminNumber)
          .collection('Customers')
          .doc(customer.id)
          .delete();

      // Reload customers after deletion
      _loadInitialCustomers();
    }
  }

  void _handleRowTap(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    final int code = int.parse(data['code'].toString());
    final String name = data['name'];
    final double currentBalance = data['balance'];
    setState(() {
      selected = !selected;
    });

    //  showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title:  Text('Balance Update',style: textTheme.headlineMedium,),
    //       content:  Text('Do you want to Top-Up or Withdraw balance?',style: textTheme.bodyMedium),
    //       actions: [

    //       ],
    //     );
    //   },
    // );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Update Balance',
            style: textTheme.headlineSmall,
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Code: $code', style: textTheme.bodyMedium),
              Text('Customer Name: $name', style: textTheme.bodyMedium),
              // const SizedBox(height: 16),
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

              // ElevatedButton(
              //   onPressed: () {
              //     _updateBalance(document, _inputAmount, true);
              //     Navigator.pop(context);
              //   },
              //   child: const Text('Top-Up Balance'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     _updateBalance(document, _inputAmount, false);
              //     Navigator.pop(context);
              //   },
              //   child: const Text('Withdraw Balance'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateBalance(document, _inputAmount, true);
                _loadInitialCustomers(); // Or trigger a refresh of the StreamBuilder

                // _showBalanceUpdateDialog(document, true); // true for Top-Up
              },
              child: const Text('Top-Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateBalance(document, _inputAmount, false);
                _loadInitialCustomers(); // Or trigger a refresh of the StreamBuilder

                // _showBalanceUpdateDialog(document, false); // false for Withdraw
              },
              child: const Text('Withdraw'),
            ),
          ],
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

    // Create a new document in the "Balance" subcollection
    await document.reference.collection('Balance').add({
      'code': data['code'], // Using the code from the document
      'date': Timestamp.now(),
      'createdBy': userNumber, // Assuming the user ID is stored in the document
      'balance': updatedBalance,
      'changedAmount': amount, // Storing the changed amount
      'type': topUp ? 'topUp' : 'withdrawal',
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Customer List'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by code, name, mobile, or email',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getCustomerStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading customers'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No customers found'));
                      }

                      // final List<DocumentSnapshot> filteredCustomers = searchQuery.isEmpty
                      //     ? customers
                      //     : snapshot.data!.docs;

                      List<DocumentSnapshot> filteredCustomers = customers;
                      customersCount = snapshot.data!.docs.length;

                      // Apply search query filtering
                      if (searchQuery != null) {
                        filteredCustomers =
                            snapshot.data!.docs.where((document) {
                          final data = document.data() as Map<String, dynamic>;
                          var code = data['code'] ?? '';
                          var name = data['name'] ?? '';
                          var mobile = data['mobile_number'] ?? '';
                          var email = data['email'] ?? '';
                          return
                              // code.contains(searchQuery) ||
                              code.toString().contains(searchQuery) ||
                                  name
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchQuery) ||
                                  mobile.contains(searchQuery) ||
                                  email
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchQuery);
                        }).toList();
                      }
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          // Trigger pagination only if scrolling down
                          if (
                              // scrollInfo.metrics.pixels ==
                              //     scrollInfo.metrics.maxScrollExtent &&
                              !isLoading &&
                                  hasMoreData &&
                                  scrollInfo.metrics.axis == Axis.vertical) {
                            _loadMoreCustomers();
                          }
                          return false;
                        },
                        child: ListView(
                            shrinkWrap: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            children: [
                              SingleChildScrollView(
                                // clipBehavior: Clip.antiAliasWithSaveLayer,
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing:
                                      MediaQuery.of(context).size.width / 8.65,
                                  headingRowHeight: 30,
                                  dataRowMinHeight: 20,
                                  headingRowColor: WidgetStatePropertyAll(
                                      Colors.orange[100]),
                                  border: TableBorder.all(
                                      width: 1.0, color: Colors.grey),
                                  columns: columns,
                                  rows: filteredCustomers
                                      .map((DocumentSnapshot document) {
                                    final data =
                                        document.data() as Map<String, dynamic>;
                                    final bool isActive = data['is_active'];

                                    final int counts =
                                        int.parse(data['code'].toString());

                                    return dataRow(
                                        data, isActive, document, counts);
                                  }).toList(),
                                ),
                              ),
                            ]),
                      );
                    },
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    color: m,
                  ),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          ),
          floatingActionButton: IconButton.outlined(
            onPressed: () async {
              final bool? customerAdded = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddC(counts: customersCount)),
              );
              if (customerAdded == true) {
                // Reload customers if a new customer was added
                _loadInitialCustomers(); // Or trigger a refresh of the StreamBuilder
              }
            },
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  DataRow dataRow(Map<String, dynamic> data, bool isActive,
      DocumentSnapshot<Object?> document, int counts) {
    return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            return null; // Use the default value.
          },
        ),
        selected: selected,
        onSelectChanged: (value) {
          setState(() {
            selected = value!;
          });
          //  void _handleRowTap(DocumentSnapshot document, int counts) {
          _handleRowTap(document);
          // }
        },
        cells: [
          DataCell(Center(child: Text(data['code'].toString()))),
          DataCell(Center(
              child: Text(
            data['name'] ?? '4',
            textAlign: TextAlign.center,
          ))),
          DataCell(Center(child: Text(data['balance_limit'].toString()))),
          DataCell(Center(child: Text(data['balance'].toString()))),
          DataCell(Row(
            children: [
              isActive
                  ? const Icon(
                      Icons.check_box,
                      color: Colors.green,
                    )
                  : const Icon(Icons.check_box_outline_blank,
                      color: Colors.red),
              isActive ? const Text('Active') : const Text('Inactive')
            ],
          )),
          DataCell(Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editCustomer(document, counts)
                    // onPressed: (){},
                    ),

                //  IconButton(
                //   icon: const Icon(Icons.info, color: Colors.blue),
                //   onPressed: () => showDialog(
                //     context: context,
                //     builder: (context) => AlertDialog(
                //        title: const Text('Customer Info'),
                //        content: Column(
                //          crossAxisAlignment:
                //              CrossAxisAlignment.start,
                //          children: [
                //            Text('Code: ${data['code']}'),
                //            Text('Name: ${data['name']}'),
                //            Text('Mobile: ${data['mobile']}'),
                //            Text('Email: ${data['email']}'),
                //            Text('Balance Limit: ${data['balance_limit']}'),
                //            Text('Balance: ${data['balance']}'),
                //            Text('Status: ${isActive? 'Active' : 'Inactive'}'),
                //          ],
                //        ),
                //      ),
                //   )),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCustomer(document),
                ),
              ],
            ),
          )),
        ]);
  }

  List<DataColumn> get columns {
    return const [
      DataColumn(
          label: Text('Code'), headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          headingRowAlignment: MainAxisAlignment.center, label: Text('Name')),
      DataColumn(
          label: Text('Balance Limit'),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('Balance'),
          headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          label: Text('Status'), headingRowAlignment: MainAxisAlignment.center),
      DataColumn(
          headingRowAlignment: MainAxisAlignment.center, label: Text('Actions'))
    ];
  }
}

// class CustomerDataSource extends DataTableSource {
//   final List<DocumentSnapshot> documents;
//   final Function(DocumentSnapshot, int)   onRowTap;

//   CustomerDataSource({required this.documents, required this.onRowTap});

//   @override
//   DataRow getRow(int index) {
//     final document = documents[index];
//     final data = document.data() as Map<String, dynamic>;
//     final int counts = index + 1;

//     return DataRow(
//       cells: [
//         DataCell(Text(data['code'].toString())),
//         DataCell(Text(data['name'])),
//         DataCell(Text(data['balance'].toString())),
//         DataCell(Text(data['balanceLimit'].toString())),
//         DataCell(Text(data['status'] ?? '')),
//       ],
//       onSelectChanged: (_) {
//         onRowTap(document, counts);
//       },
//     );
//   }

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get rowCount => documents.length;

//   @override
//   int get selectedRowCount => 0;

// }
