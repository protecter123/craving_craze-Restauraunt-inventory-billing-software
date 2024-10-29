import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/utils.dart';
import '../../Admin/admin_home.dart';
import '../../Authentication Screens/Phone Auth Screen/phone_auth.dart';
import '../../Users/user_home.dart';
import '../Connectivity/connectivity_model.dart';
import '../Connectivity/no_connection.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Timer(const Duration(seconds: 3), () async {
      await _checkUserRole();
    });
  }

  Future<void> _checkUserRole() async {
    final ConnectivityModel connectivityModel =
        Provider.of<ConnectivityModel>(context, listen: false);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String phoneNumber = currentUser.phoneNumber!;
      Map<String, bool> roleMap = await checkAdminOrUserExists(phoneNumber);

      if (roleMap['isAdmin'] == true && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  connectivityModel.hasInternet ? AdminHome() : NoConnection()),
        );
      } else if (roleMap['isUser'] == true && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  connectivityModel.hasInternet ? UserHome() : NoConnection()),
        );
      } else {
        // Handle the case where the user is neither admin nor user
        // e.g., navigate to a sign-up or error page
      }
    } else {
      print(
          'connecting to phone authentication: ${connectivityModel.hasInternet}');
      // User is not authenticated, navigate to PhoneAuthPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                connectivityModel.hasInternet ? PhoneAuth() : NoConnection()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme;
    return Scaffold(
      // backgroundColor: m,
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          direction: Axis.vertical,
          // runSpacing:100,
          spacing: 50,
          alignment: WrapAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * 3.1415,
                  child: AnimatedOpacity(
                    opacity: _controller.value,
                    duration: const Duration(seconds: 1),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 190,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )),
                    ),
                  ),
                );
              },
            ),

            FadeTransition(
              opacity: _animation,
              child: RichText(
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Welcome!\n',
                    style: title.titleLarge,
                  ),
                  TextSpan(
                      text: 'We are glad to see you', style: title.bodySmall)
                ]),
              ),
            ),

// FadeTransition(opacity: _animation,child: Column(children: [const CircularProgressIndicator(),
//
//   Text('Loading...',style: title.bodyLarge,)],),)
          ],
        ),
      ),
    );
  }
}
