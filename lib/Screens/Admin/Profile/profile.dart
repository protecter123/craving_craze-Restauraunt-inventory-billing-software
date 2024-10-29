// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AdminProfile extends StatefulWidget {
//   const AdminProfile({super.key});

//   @override
//   AdminProfileState createState() => AdminProfileState();
// }

// class AdminProfileState extends State<AdminProfile> {
//   String address = "Gurgaon";
//   // String createdAt = "August 23, 2024 at 11:39:02 AM UTC+5:30";
//   String email = "admin@cravingcraze.com";
//   // String images = "";
//   String name = "Admin";
//   List<String> packages = ["0"];
//   String uid = "+919999999999";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('Name: $name'),
//               Text('Address: $address'),
//               // Text('Created At: $createdAt'),
//               Text('Email: $email'),
//               // Text('Images: $images'),
//               Text('Packages: ${packages.join(", ")}'),
//               Text('UID: $uid'),
//               const SizedBox(height: 20),
//               // ElevatedButton(
//               //   onPressed: _saveProfileToFirebase,
//               //   child: Text('Save to Firebase'),
//               // ),
//               // ElevatedButton(
//               //   onPressed: _saveProfileToSharedPreferences,
//               //   child: Text('Save to SharedPreferences'),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveProfileToFirebase() async {
//     CollectionReference adminProfile =
//         FirebaseFirestore.instance.collection('adminProfiles');

//     await adminProfile.doc(uid).set({
//       'address': address,
//       // 'createdAt': Timestamp.fromDate(DateTime.parse(createdAt)),
//       'email': email,
//       // 'images': images,
//       'name': name,
//       'packages': packages,
//       'uid': uid,
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile saved to Firebase!')),
//     );
//   }

//   Future<void> _saveProfileToSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     await prefs.setString('address', address);
//     // await prefs.setString('createdAt', createdAt);
//     await prefs.setString('email', email);
//     // await prefs.setString('images', images);
//     await prefs.setString('name', name);
//     await prefs.setStringList('packages', packages);
//     await prefs.setString('uid', uid);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Profile saved to SharedPreferences!')),
//     );
//   }
// }

import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/utils.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  AdminProfilePageState createState() => AdminProfilePageState();
}

class AdminProfilePageState extends State<AdminProfilePage> {
 static bool _isEditing = false, _isAdmin = false;


  // Sample data

  String name = "";
  String address = "";
  String email = "";
  String phoneNumber = '' ;
      // SharedPreferencesHelper.getString('adminNumber'); 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

 Future<void> _loadProfileData() async {
  // Check if mobileNo is not null
  if (mobileNo == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mobile number is required')),
    );
    return;
  }

  // Check if the user is an admin or a user
  Map<String, bool> status = await checkAdminOrUserExists(mobileNo!);
  print('Status: A ${status['isAdmin']} , U ${status['isUser']}');

  // Load data from Firestore
  try {
    if (status['isAdmin'] == true) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(mobileNo)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          name = doc['name'] ?? '';
          address = doc['address'] ?? '';
          email = doc['email'] ?? '';
          phoneNumber = doc['uId'] ?? '';
          _nameController.text = name;
          _addressController.text = address;
          _emailController.text = email;
          _isAdmin = true;
        });
      }
    } else if (status['isUser'] == true) {
      // Load user data from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(adminNumber) // Ensure adminNumber is defined and valid
          .collection('Users')
          .doc(mobileNo)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          name = doc['name'] ?? '';
          address = doc['address'] ?? '';
          email = doc['email'] ?? '';
          phoneNumber = doc['uId'] ?? '';
          _nameController.text = name;
          _addressController.text = address;
          _emailController.text = email;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User or Admin not found')),
      );
    }
  } catch (e) {
    print('Error loading profile data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while loading data')),
    );
  }
}
  Future<void> _updateProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('email', _emailController.text);

    // Update Firestore
    await FirebaseFirestore.instance.collection('Admins').doc(phoneNumber).set({
      'name': _nameController.text,
      'address': _addressController.text,
      'email': _emailController.text,
    }, SetOptions(merge: true)); // Merge to avoid overwriting other fields
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _updateProfileData();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    // final isTablet = screenWidth >= 600 && screenWidth < 1024;
print(_isAdmin);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdmin?
          'Admin Profile': 'User Profile', 
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
        iconTheme: const IconThemeData(
            color: Colors.white), // Set the back icon color to white

        elevation: 0,
      ),
      body: Container(
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 800, minHeight: 400, maxHeight: 520),
            child: Card(
              margin: EdgeInsets.all(isDesktop ? 32 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 20 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                            controller: _nameController,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          )
                        : Text(
                            name,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          ),
                          if(_isAdmin)...[
                    const SizedBox(height: 16),
                    // if(_isAdmin)
                    Text(
                      'Address:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 20 : 16,
                      ),
                    ),
                    // if(_isAdmin)
                    const SizedBox(height: 8),
                    // if(_isAdmin)
                    _isEditing 
                        ? TextField(
                            controller: _addressController,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          )
                        : Text(
                            address,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          ),
                          ],
                    const SizedBox(height: 16),
                    Text(
                      'Email:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 20 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _isEditing
                        ? TextField(
                            controller: _emailController,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          )
                        : Text(
                            email,
                            style: GoogleFonts.montserrat(
                                fontSize: isDesktop ? 18 : 14),
                          ),
                    const SizedBox(height: 16),
                    Text(
                      'Phone Number:',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 20 : 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      phoneNumber,
                      style:
                          GoogleFonts.montserrat(fontSize: isDesktop ? 18 : 14),
                    ), // Non-editable field
                    _isEditing
                        ? const SizedBox(height: 30)
                        : const SizedBox(height: 80),
                    Center(
                      child: ElevatedButton(
                        onPressed: _toggleEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lm,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 32 : 16,
                            vertical: isDesktop ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'Save' : 'Edit',
                          style: GoogleFonts.montserrat(
                            fontSize: isDesktop ? 18 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
