import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';

//Colors
const Color m = Color(0XFFc44720);
const Color sec = Color(0XFFb4441e);
const Color lm = Color(0XFFd8946c);

//Animations

const String addUser = 'assets/animations/addUser.json';
const String addUserIcon = 'assets/animations/addUserIcon.json';
const String profile = 'assets/animations/profile.json';
const String addCategory = 'assets/animations/addcategory.json';

//Gap for space between widgets in row and column
class Gap {
  static Widget h(double height) => SizedBox(height: height);

  static Widget w(double width) => SizedBox(width: width);
}

/// Pushes a new route onto the navigation stack.
///
/// The [context] and [page] parameters must not be null.
///
/// The [arguments] parameter is optional and can be used to pass data to the new route.
void push(BuildContext context, Widget page, {Object? arguments}) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments)),
  );
}

/// Replaces the current route with a new route.
///
/// The [context] and [page] parameters must not be null.
///
/// The [arguments] parameter is optional and can be used to pass data to the new route.
void replace(BuildContext context, Widget page, {Object? arguments}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(arguments: arguments)),
  );
}

/// Removes all previous routes and replaces them with a new route.
///
/// The [context] and [page] parameters must not be null.
///
/// The [arguments] parameter is optional and can be used to pass data to the new route.
void remove(BuildContext context, Widget page, {Object? arguments}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(arguments: arguments)),
      (route) => false);
}

/// Checks if an Admin or User exists in the Firestore database.
///
/// The [phoneNumber] parameter is the phone number of the Admin or User to check.
///
/// Returns a Future<bool> indicating whether the Admin or User exists.
Future<Map<String, bool>> checkAdminOrUserExists(String phoneNumber) async {
  bool isAdmin = false, isUser = false;
  // Check if the Admin exists
  if ((await FirebaseFirestore.instance
          .collection('Admins')
          .doc(phoneNumber)
          .get())
      .exists) {
    isAdmin = true;
    SharedPreferencesHelper.setString('adminNumber', phoneNumber);
  }

  // Check if the User exists in any Admin's users subcollection
  else {
    var adminDocs = await FirebaseFirestore.instance.collection('Admins').get();
    for (var adminDoc in adminDocs.docs) {
      if ((await adminDoc.reference.collection('Users').doc(phoneNumber).get())
          .exists) {
        // print('Admin number:  ${ adminDoc.reference.id}');
        String adminNumber = adminDoc.reference.id; // Save the admin number

        // User exists in this Admin's users subcollection
        isUser = true;
        SharedPreferencesHelper.setString('userNumber', phoneNumber);
        SharedPreferencesHelper.setString('adminNumber', adminNumber);
        break;
      }
    }
  }

  // Return the result as a map
  return {'isUser': isUser, 'isAdmin': isAdmin};
}

void showSnackbar(BuildContext context, String message, {Color color = m}) {
  // Create the snackbar
  final snackbar = SnackBar(
    content: Text(message),
    backgroundColor: color,
    duration: const Duration(seconds: 3),
  );

  // Show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}



                      // IconButton(
                      //   icon: const Icon(Icons.edit),
                      //   onPressed: () {
                      //     // Open a dialog to edit the user
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         final _nameController = TextEditingController(text: user['name']);
                      //         return AlertDialog(
                      //           title: const Text('Edit User'),
                      //           content: TextField(
                      //             controller: _nameController,
                      //             decoration: const InputDecoration(
                      //               labelText: 'Name',
                      //             ),
                      //           ),
                      //           actions: [
                      //             TextButton(
                      //               child: const Text('Cancel'),
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //             TextButton(
                      //               child: const Text('Save'),
                      //               onPressed: () {
                      //                 FirebaseFirestore.instance.collection('Admins').doc(number).collection('Users').doc(users[index].id).update({
                      //                   'name': _nameController.text,
                      //                 });
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // IconButton(
                      //   icon: const Icon(Icons.delete),
                      //   onPressed: () {
                      //     // Confirm deletion
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title:  Text('Delete User',style: textTheme.bodyLarge,),
                      //           content: Text('Are you sure you want to delete this user?',style: textTheme.bodyMedium,),
                      //           actions: [
                      //             TextButton(
                      //               child: const Text('Cancel'),
                      //               onPressed: () {
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //             TextButton(
                      //               child: const Text('Delete',style: TextStyle(color: Colors.red),),
                      //               onPressed: () {
                      //                 FirebaseFirestore.instance.collection('Admins').doc(number).collection('Users').doc(users[index].id).delete();
                      //                 Navigator.of(context).pop();
                      //               },
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),