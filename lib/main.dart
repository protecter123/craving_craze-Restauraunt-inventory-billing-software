import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Function/Fetch all data/dataprovider.dart';
import 'Screens/Admin/Account Movement/customer_provider.dart';
import 'Screens/Admin/Groups/Department/department_controller.dart';
import 'Screens/Admin/Groups/group_provider.dart';
import 'Screens/Admin/Profile/profile_provider.dart';
import 'Screens/Admin/Registration/Cart/cart_provider.dart';
import 'Screens/Admin/Registration/Table/table_info_provider.dart';
import 'Screens/Admin/Setting/Media/media_provider.dart';
import 'Screens/Authentication Screens/OTP Screen/otp_provider.dart';
import 'Screens/Splash/Connectivity/connectivity_model.dart';
import 'Screens/Splash/Primary/splash.dart';
import 'Utils/Global/global.dart';
import 'Utils/Theme Data/theme_data.dart';
import 'firebase_options.dart';

/// This is the main entry point of the Craving Craze application.
/// It initializes Firebase, sets up the application's theme, and provides necessary providers.
///
/// The main function performs the following tasks:
/// 1. Initializes Flutter's binding.
/// 2. Initializes Firebase with a custom app name and default Firebase options.
/// 3. Initializes shared preferences.
/// 4. Sets up the application's providers using the Provider package.
/// 5. Builds and runs the MaterialApp with the specified theme and home screen.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //   SystemChrome.setPreferredOrientations([
  // DeviceOrientation.portraitUp,
  //   ]);
  await Firebase.initializeApp(
    name: 'craving-craze',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper().init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => OTPProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => DepartmentController()),
      ChangeNotifierProvider(create: (_) => GroupProvider()),
      ChangeNotifierProvider(create: (_) => MediaProvider()),
      ChangeNotifierProvider(create: (_) => ConnectivityModel()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => TableInfoProvider()),
      ChangeNotifierProvider(create: (_) => CustomerProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Craving Craze',
      theme: themeData,
      home: const Splash(),
    );
  }
}
