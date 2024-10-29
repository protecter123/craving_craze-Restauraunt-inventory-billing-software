import 'package:craving_craze/Screens/Authentication%20Screens/Phone%20Auth%20Screen/phone_auth.dart';
import 'package:craving_craze/Screens/Splash/Connectivity/connectivity_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({super.key});

  @override
  State<NoConnection> createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    // Add a post frame callback to ensure the connection is checked after the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialConnectivity();
    });
  }

  // Dispose of the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Check the internet connection right after the page loads
  void _checkInitialConnectivity() {
    var hasInternet = context.read<ConnectivityModel>().hasInternet;
    if (hasInternet) {
      // If internet is available, navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneAuth()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var hasInternet = context.watch<ConnectivityModel>().hasInternet;

    // If internet is available, immediately redirect to PhoneAuth
    if (hasInternet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PhoneAuth()),
        );
      });
      return const SizedBox(); // Return an empty widget while waiting to navigate
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                ScaleTransition(
                    scale: _animation,
                    child: ClipOval(
                        child: Image.asset('assets/images/internet error.jpg'))),
                const SizedBox(height: 60),
                Text(
                  'Oops! 😓',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                Text(
                  'No internet connection found.\nCheck your connection or try again',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    // Recheck the internet connection when "Try Again" is pressed
                    if (hasInternet) {
                      // Navigate to the next page if the connection is restored
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const PhoneAuth()),
                      );
                    } else {
                      // Show a SnackBar message if no internet is found
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.redAccent,
                        content: const Center(
                          child: Text('No internet connection!'),
                        ),
                      ));
                    }
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
