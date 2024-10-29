import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/utils.dart';
import 'add_users.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> with TickerProviderStateMixin {
  late TabController _tabController;
  //  String _selectedValue = 'Select Profile';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Users'),

          centerTitle: true,
          // bottom: TabBar(
          //       controller: _tabController,
          //       tabs: [
          //         Tab(text: 'Cashiers'),
          //         Tab(text: 'Promotors'),
          //         Tab(text: 'Merchants'),
          //       ],
          //     ),
          actions: [
            IconButton(
              icon: Lottie.asset(addUserIcon,
                  height: 50, width: 50, fit: BoxFit.contain),
              onPressed: () => push(context, const AddUsers()),
            ),
          ],
        ),
        body: _buildStreamBuilder()

        // TabBarView(
        //   // viewportFraction:1,
        //     controller: _tabController,
        //     children: [
        //       _buildStreamBuilder('Cashier'),
        //       _buildStreamBuilder('Promotor'),
        //       _buildStreamBuilder('Merchant'),
        //     ],
        //   ),
        );
  }

  Widget _buildStreamBuilder(
      // String profile
      ) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Admins')
            .doc(adminNumber)
            .collection('Users')
            // .where('profile', isEqualTo: profile)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return Center(
                  child: Text(
                'No users found',
                style: textTheme.bodyLarge?.copyWith(color: Colors.black),
              ));
            }
            final users = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Swipe left to delete',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ),
                  Gap.h(10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index].data();
                        final userId = users[index].id;

                        final userProfile = user['profile'] ?? 'Select';
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: ValueKey(userId),
                          onDismissed: (direction) {
                            // Remove the item from Firestore
                            FirebaseFirestore.instance
                                .collection('Admins')
                                .doc(adminNumber)
                                .collection('Users')
                                .doc(userId)
                                .delete();
                            // Show a snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("${user['name']} deleted"),
                              ),
                            );
                          },
                          background: const Card(
                            color: Colors.redAccent,
                            child: Center(
                              child: Icon(
                                Icons.delete_sweep_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Card(
                            // shadowColor: Colors.green,
                            // color: Colors.black,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              // tileColor: Colors.amber,
                              leading: const CircleAvatar(
                                  backgroundColor: lm,
                                  child: Icon(
                                    Icons.person_2,
                                    color: m,
                                  )),
                              //  Lottie.asset(profile,),
                              title: Text(user['name']),
                              subtitle: Text(user['uId'] ?? ''),
                              trailing: Wrap(
                                //  crossAxisAlignment: CrossAxisAli

                                children: [
                                  DropdownButton<String>(
                                    itemHeight: kMinInteractiveDimension,
                                    isDense: true,
                                    iconSize: 18,
                                    borderRadius: BorderRadius.circular(10),
                                    isExpanded: false,
                                    style: textTheme.bodySmall,
                                    padding: EdgeInsets.zero,

                                    // value: user['profile'] != null && ['Merchant', 'Cashier', 'Promoter'].contains(user['profile']) ? user['profile'] : 'select',
                                    value: userProfile,

                                    onChanged: (value) {
                                      if (value != null &&
                                          value != userProfile) {
                                        FirebaseFirestore.instance
                                            .collection('Admins')
                                            .doc(adminNumber)
                                            .collection('Users')
                                            .doc(userId)
                                            .update({'profile': value});
                                      }
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                        alignment: Alignment.center,
                                        value: 'Select',
                                        child: Text('Select'),
                                      ),
                                      DropdownMenuItem(
                                          alignment: Alignment.center,
                                          value: 'Merchant',
                                          child: Text('Merchant')),
                                      DropdownMenuItem(
                                          alignment: Alignment.center,
                                          value: 'Cashier',
                                          child: Text('Cashier')),
                                      DropdownMenuItem(
                                          alignment: Alignment.center,
                                          value: 'Promoter',
                                          child: Text('Promoter')),
                                    ],
                                  ),
                                  // IconButton(
                                  //   onPressed: () => FirebaseFirestore.instance
                                  //           .collection('Admins')
                                  //           .doc(adminNumber)
                                  //           .collection('Users')
                                  //           .doc(userId)
                                  //           .delete() ,
                                  //   icon: Icon(Icons.delete_sweep_rounded,color: Colors.red.shade400,),)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Text('Unknown state: ${snapshot.connectionState}');
        });
  }
}

// Widget iconAnimation(){

// return Stack(
//   children: [
// Container(
//   color:lm,
//   alignment: Alignment.centerRight,
//   padding: const EdgeInsets.only(right: 20),
//   child: Opacity(opacity: 0.0,child: Icon(Icons.delete_sweep_rounded,color:Colors.red.shade400,),),
// ),
// AnimatedBuilder(animation: Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: AnimationController(vsync: this,duration: Duration(microseconds: 300)), 
// curve:Curves.easeInOut )), builder: (context, child)){
//   return Positioned(child: Opacity(opacity: Tween<double>(begin: 1.0,end: 0.0))
// }

//   ],
// );
// }