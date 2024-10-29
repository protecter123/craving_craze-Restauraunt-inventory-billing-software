import 'package:craving_craze/Screens/Admin/Account%20Movement/account_movement1.dart';

import 'package:flutter/material.dart';

import '../Admin/Purchase List/purchase_list.dart';
import '../Users/Balance Overview/balance_overview.dart';
import '../Users/Balance Screen/balance.dart';
import '../Users/test/view_customer.dart';

class BottomTabBarPage extends StatelessWidget {
  const BottomTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Bottom TabBar Example'),
        // ),
        body: TabBarView(
          children: [
            CustomerListPage(),
            BalancePage(),
            BalanceOverviewPage(),
            PurchaseListPage(),
            AccountMovementPage1(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorWeight: .5,
            tabs: [
              Tab(text: 'Customers'),
              Tab(text: 'Balance'),
              Tab(text: 'Top Up/Withdraw Report'),
              Tab(text: 'Purchase List'),
              Tab(text: 'Account Movement'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
