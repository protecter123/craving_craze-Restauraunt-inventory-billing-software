import 'package:craving_craze/Utils/Global/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Function/Firebase/get_data.dart';
import '../../../../Function/Local Database/localdatabase.dart';
import '../profile_modal.dart';
import '../profile_provider.dart';

// class ShowData extends StatelessWidget {
//   const ShowData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Show Data'),
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         children: [HomePage5(),
//         //  ProfilePage(), BrandsPage(), ProfileDropdown()
//         ],
//       ),
//     );
//   }
// }

class HomePage5 extends StatelessWidget {
  const HomePage5({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User user = await firebaseService
                .fetchUser(adminNumber!); // Replace with actual userId
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Text('Load User Profile'),
        ),
      ),
    );
  }
}

// pages/profile_page.dart

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: Text('User  Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: user.name),
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                user.name = value; // Update user object
              },
            ),
            TextField(
              controller: TextEditingController(text: user.email),
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                user.email = value; // Update user object
              },
            ),
            TextField(
              controller: TextEditingController(text: user.address),
              decoration: InputDecoration(labelText: 'Address'),
              onChanged: (value) {
                user.address = value; // Update user object
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final databaseHelper = DatabaseHelper.instance;
                await databaseHelper.updateUser(user);
                final firebaseService = FirebaseService();
                await firebaseService.updateUser(user);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// pages/brands_page.dart

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(title: Text('Brands')),
      body: ListView.builder(
        itemCount: user.brands.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(user.brands[index].name),
            leading: Image.network(user.brands[index].image),
          );
        },
      ),
    );
  }
}

// widgets/profile_dropdown.dart

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return DropdownButton(
      value: user.profiles[0],
      onChanged: (value) {
        // Update user profile
        user.profiles[0] = value!;
      },
      items: user.profiles.map((profile) {
        return DropdownMenuItem(
          value: profile,
          child: Text(profile),
        );
      }).toList(),
    );
  }
}
