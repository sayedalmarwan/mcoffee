import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Navigate to WelcomePage after 3 seconds
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
          // Background Image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.3), // Dark overlay
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/images/startup_background.jpg', // Use your actual image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo & Title
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/vector.png', // Use your actual logo
                  height: 100,
                ),
                const SizedBox(height: 20),
                Text(
                  "Magic Coffee",
                  style: GoogleFonts.pacifico(
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
