import 'package:craving_craze/Screens/Admin/Groups/groups_view.dart';
import 'package:craving_craze/Screens/Admin/Products/products.dart';
import 'package:craving_craze/Screens/Admin/Profile/profile.dart';
import 'package:craving_craze/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animations/animations.dart';

import '../../Function/Fetch all data/test_brand.dart';
import '../../Utils/Global/global.dart';
import '../Authentication Screens/Phone Auth Screen/phone_auth.dart';
import 'Groups/Department/department_page.dart';
import 'Products/Stocks Management/stocks_management.dart';
import 'Products/test/add_and_edit_categories.dart';

import 'Profile/test/show_data.dart';
import 'Registration/pos_interface.dart';
import 'users.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size
              // .fromHeight
              (
            // height > 600 ? height * 0.5 : height * .10,
            double.infinity,
            height > 600 ? height * .08 : height * .17,
          ),
          child: Container(
            // height: height > 600 ? height * 0.20 : height * .45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // borderRadius: BorderRadius.only(
              //   bottomLeft: Radius.circular(40),
              //   bottomRight: Radius.circular(40),
              // ),
            ),
            child: AppBar(
              scrolledUnderElevation: 0,
              excludeHeaderSemantics: true,
              bottomOpacity: 0,
              forceMaterialTransparency: true,
              backgroundColor: Colors.transparent,
              // elevation: 6,

              leadingWidth: 60,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OpenContainer(
                  closedShape: const CircleBorder(),
                  transitionType: ContainerTransitionType.fade,
                  transitionDuration: const Duration(milliseconds: 500),
                  closedBuilder: (context, openContainer) {
                    return const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 30, color: Colors.black),
                    );
                  },
                  openBuilder: (context, closeContainer) {
                    return const AdminProfilePage();
                  },
                ),
              ),
              title: Text(
                'ADMIN',
                style: GoogleFonts.ptMono(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sign Out',
                                  style: textTheme.headlineMedium),
                              content: Text(
                                  'Are you sure you want to sign out?',
                                  style: textTheme.bodyLarge),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('No',
                                      style: TextStyle(color: m)),
                                ),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.of(context).pop(),
                                          auth.signOut(),
                                          remove(context, const PhoneAuth()),
                                        },
                                    child: const Text('Yes',
                                        style: TextStyle(color: m))),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white)),
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            // Top Section with Gradient Background
            Container(
              height: height > 600 ? height * 0.08 : height * .20,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // const Spacer(),

                  // const SizedBox(height: 5),
                  const Text(
                    'HI, ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'You can access all your data here..',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimationLimiter(
                child: GridView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width > 600 ? 4 : 2, // Responsive grid
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: buildQuickAction(
                            context,
                            getIcon(index),
                            getLabel(index),
                            getColor(index),
                            action(context, index),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
      case 6:
        return Icons.local_fire_department;
      case 7:
        return Icons.group;
      default:
        return Icons.error;
    }
  }

  String getLabel(int index) {
    switch (index) {
      case 0:
        return 'USERS';
      case 1:
        return 'PRODUCTS';
      case 2:
        return 'STOCKS';
      case 3:
        return 'UNITS';
      case 4:
        return 'CATEGORY';
      case 5:
        return 'ALL-ITEM';
      case 6:
        return 'DEPARTMENT';
      case 7:
        return 'GROUPS';
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
      case 6:
        return Colors.brown;
      case 7:
        return Colors.amber;
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
        return () => push(context, const Users());
      case 1:
        return () => push(context, const Products()
            // Scaffold(appBar: AppBar(title: Text('Items'),),)
            );
      case 2:
        return () => push(context, const ProductManagementPage()
            //  DepartmentPage(),
            // AddC()
            // Scaffold(appBar: AppBar(title: const Text('Unknow'),),)
            );
      case 3:
        return () => push(context,
        HomePage5()
        //  ShowData()
            // BrandsScreen()
            // BottomTabBarPage()
// NoConnection()
            // CustomerTablePage()
            // AddProductPage()
            );
      case 4:
        return () => push(context, const AddAndEditCategories()
            // ReceiptSetting()
            // TableInfo()
            // AccountMovementPage()
            );
      case 5:
        return () => push(context, PosInterface()
            // MediaPage()
            // GroupsView()
            // ReceiptSetting()
            // PurchaseListPage()
            );
      case 6:
        return () => push(context, DepartmentViewPage()
            // GroupsView()
            // MediaPage()
            // ReceiptSetting()
            // PurchaseListPage()
            );
      case 7:
        return () => push(context, GroupsView()
            // ReceiptSetting()
            // PurchaseListPage()
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
