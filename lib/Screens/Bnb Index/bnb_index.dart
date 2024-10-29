import 'package:flutter/material.dart';

import '../../Utils/utils.dart';
import '../Admin/admin_home.dart';

class BnbIndex extends StatefulWidget {
  const BnbIndex({super.key});

  @override
  State<BnbIndex> createState() => _BnbIndexState();
}

class _BnbIndexState extends State<BnbIndex> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminHome(),
    const OrdersScreen(),
    const HistoryScreen(),
    const ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.shopping_bag, 'Orders', 1),
            _buildNavItem(Icons.history, 'History', 2),
            _buildNavItem(Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: index == currentIndex ? m : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: index == currentIndex ? m : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Homep'),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Orders Screen'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Welcome to your profile!')),
    );
  }
}


// class BnbIndex extends StatefulWidget {
//   const BnbIndex({super.key});

//   @override
//   State<BnbIndex> createState() => _BnbIndexState();
// }

// class _BnbIndexState extends State<BnbIndex> {
//   // String? city = SharedPreferencesHelper.getString('city'),
//       // state = SharedPreferencesHelper.getString('state');
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     // const DashboardScreen(),
//     HomePage(),
//     ProfilePage()
//     // const OrdersPage(),
//     // const History(),
//     // AccountPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // city = city?.toLowerCase();
//     // state = state?.toLowerCase();
//     return Scaffold(

//       body: 
//       // city == 'rajkot' && state == 'gujarat'
//           // ? 
//           _screens[_currentIndex],
//           // : const OutOfServices(),
//       bottomNavigationBar: 
//       // city == 'rajkot' && state == 'gujarat'?
//       // CustomTabBar(onTabChange: _onItemTapped,selectedIndex: _currentIndex,)
//       CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onItemTapped,
//       )
//             // :const SizedBox.shrink(),
//     );
//   }
// }

// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavigationBar(
//       {super.key, required this.currentIndex, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       // color: Colors.blue,
//       shadowColor: Colors.black,
//       height: 68,
//       child: Container(
// // height: 100,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5), color: Colors.white70),
//         child: Stack(
//           children: [Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(Icons.home, 'Home', 0),
//               // _buildNavItem(Icons.shopping_bag, 'Orders', 1),
//               // _buildNavItem(Icons.history, 'History', 2),
//               _buildNavItem(Icons.person, 'Profile', 1),
//             ],
//           ),
//             TweenAnimationBuilder<double>(
//               tween: Tween<double>(
//                 begin: (currentIndex * MediaQuery.of(context).size.width / 4) + MediaQuery.of(context).size.width / 8 - 20,
//                 end: (currentIndex * MediaQuery.of(context).size.width / 4) + MediaQuery.of(context).size.width / 8 - 20,
//               ),
//               duration: const Duration(milliseconds: 300),
//               builder: (context, position, child) {
//                 return Positioned(
//                   bottom: 0,
//                   left: position,
//                   child: Container(
//                     width: 40, // Indicator width
//                     height: 4, // Indicator height
//                     color: Colors.blue, // Color of the indicator
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     return GestureDetector(
//       onTap: () => onTap(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: index == currentIndex ? m : Colors.grey),
//           Text(
//             label,
//             style: TextStyle(
//               color: index == currentIndex ? m : Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class OutOfServices extends StatelessWidget {
// //   const OutOfServices({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         backgroundColor: m,
// //         body: popUp(context, 'Out of Services',
// //             'We apologize for any inconvenience caused by the temporary interruption of our service in your city or state. Our teams are diligently working to resolve the issue as quickly as possible. We appreciate your patience and understanding during this time.',
// //         SizedBox(
// //           height: 120,
// //           width: 120,
// //           child: Lottie.asset('assets/animations/caution.json',fit: BoxFit.fill),),),);
// //   }
// // }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Welcome to the Home Page!',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               child: Text('Go to Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'This is the Profile Page!',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }