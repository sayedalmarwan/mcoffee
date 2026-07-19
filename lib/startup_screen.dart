import 'package:flutter/material.dart';
import 'package:mcoffee/welcome.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/startup_background.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/vector.png', height: 100),
                const SizedBox(height: 20),
                const Text(
                  "Magic Coffee",
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
