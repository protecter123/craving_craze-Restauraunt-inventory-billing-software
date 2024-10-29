

import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/Global/global.dart';
import '../../Utils/utils.dart';
import '../Admin/Account Movement/account_movement1.dart';
import '../Admin/Products/Stocks Management/stocks_management.dart';
import '../Admin/Profile/profile.dart';
import '../Admin/Purchase List/purchase_list.dart';
import '../Authentication Screens/Phone Auth Screen/phone_auth.dart';
import '../Tabbar/bottom_tab_bar.dart';
import 'Balance Overview/balance_overview.dart';
import 'Balance Screen/balance.dart';
import 'test/new_customers.dart';
import 'test/view_customer.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            clipBehavior: Clip.hardEdge,
            backgroundColor: Colors.pinkAccent.withAlpha(250),
            semanticLabel: 'Connect',
            width: height > 600 ? width * .70 : width * .50,
            child: ListView(children: <Widget>[
              Center(
                  child: DrawerHeader(
                      padding: EdgeInsets.all(70),
                      margin: EdgeInsets.zero,
                      child: Text(
                        'Menu',
                        style: textTheme.bodyLarge,
                      ))),
              ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text('Logout'),
                onTap: () => logout(context, auth),
              )
            ]),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            height > 600 ? height * .08 : height * .17,
          ),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 60,
              leading: Builder(builder: (context) {
                return 
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              title: Text(
                'USER',
                style: GoogleFonts.ptMono(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                animatedProfile(),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CustomerListPage(),
            BalancePage(),
            BalanceOverviewPage(),
            PurchaseListPage(),
            AccountMovementPage1(),
          ],
        ),

        // Column(
        //   children: [
        // Top Section with Gradient Background

        // Contact Information Section
        // Container(
        //   // color: Colors.black,
        //   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //       buildContactInfo('+919999999999', 'Phone-No'),
        //       buildContactInfo('snehil@gmail.com', 'E-mail'),
        //     ],
        //   ),
        // ),
        // Quick Actions Section with Animation and Better Layout Handling

        // Padding(
        //   padding: const EdgeInsets.all(20.0),
        //   child: AnimationLimiter(
        //     child: GridView.builder(
        //       physics: const ScrollPhysics(),
        //       shrinkWrap: true,
        //       itemCount: 6,
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: width > 600 ? 4 : 2, // Responsive grid
        //         crossAxisSpacing: 20,
        //         mainAxisSpacing: 20,
        //         childAspectRatio: 1,
        //       ),
        //       itemBuilder: (context, index) {
        //         return AnimationConfiguration.staggeredGrid(
        //           position: index,
        //           duration: const Duration(milliseconds: 500),
        //           columnCount: 2,
        //           child: ScaleAnimation(
        //             child: FadeInAnimation(
        //               child: buildQuickAction(
        //                 context,
        //                 getIcon(index),
        //                 getLabel(index),
        //                 getColor(index),
        //                 action(context, index),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
        // ],
        // ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(5),
          child: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicatorWeight: 1,
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

  Future<dynamic> logout(BuildContext context, FirebaseAuth auth) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: textTheme.headlineMedium,
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'No',
                style: TextStyle(color: m),
              ),
            ),
            
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                auth.signOut();
                remove(context, const PhoneAuth());
              },
              child: const Text('Yes', style: TextStyle(color: m)),
            ),
          ],
        );
      },
    );
  }

  Padding animatedProfile() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: OpenContainer(
        closedShape: const CircleBorder(),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 500),
        closedBuilder: (context, openContainer) {
          return const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 30, color: Colors.black),
          );
        },
        openBuilder: (context, closeContainer) {
          return const AdminProfilePage();
        },
      ),
    );
  }

  Widget buildContactInfo(String text, String label) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget buildQuickAction(BuildContext context, IconData icon, String label,
      Color color, VoidCallback? ontap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person;
      case 1:
        return Icons.fastfood;
      case 2:
        return Icons.attach_money;
      case 3:
        return Icons.balance;
      case 4:
        return Icons.category;
      case 5:
        return Icons.assignment;
      default:
        return Icons.error;
    }
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return 'USERS';
      case 1:
        return 'ITEMS';
      case 2:
        return 'ALL USERS';
      case 3:
        return 'UNITS';
      case 4:
        return 'CATEGORY';
      case 5:
        return 'ALL-ITEM';
      default:
        return 'UNKNOWN';
    }
  }

  Color getColor(int index) {
    switch (index) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.pinkAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      case 5:
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  VoidCallback? action(
    BuildContext context,
    int index,
  ) {
    switch (index) {
      case 0:
        return () => push(context, const CustomerListPage());
      case 1:
        return () => push(context, const BalancePage()
            // Scaffold(appBar: AppBar(title: Text('Items'),),)
            );
      case 2:
        return () => push(context, const CustomerPage()
            // Scaffold(appBar: AppBar(title: const Text('Unknow'),),)
            );
      case 3:
        return () => push(context, const BalanceOverviewPage()
            // Scaffold(appBar: AppBar(title: const Text('Units'),),)
            );
      case 4:
        return () => push(context, const ProductManagementPage()
            // Scaffold(appBar: AppBar(title: const Text('Category'),),)
            );
      case 5:
        return () => push(context, BottomTabBarPage()
            // const ChangeProductsIdentities()
            // Scaffold(appBar: AppBar(title: const Text('All-Items'),),)
            );
      default:
        return () => push(
            context,
            Scaffold(
              appBar: AppBar(
                title: const Text('Unknown'),
              ),
            ));
    }
  }
}

// Future<void> getAdminData(){

// }
