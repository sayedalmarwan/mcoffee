import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mcoffee/cafe.dart';
import 'package:mcoffee/confirmed_page.dart';
import 'package:mcoffee/forgot_password.dart';
import 'package:mcoffee/menu.dart';
import 'package:mcoffee/profile.dart';
import 'firebase_options.dart';
import 'package:mcoffee/signin.dart';
import 'package:mcoffee/startup_screen.dart';
import 'package:mcoffee/welcome.dart';
import 'package:mcoffee/signup.dart';
import 'package:mcoffee/theme.dart'; // Import the theme file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: buildTheme(), // Use the theme from theme.dart
      initialRoute: '/',
      routes: {
        '/': (context) => const StartupScreen(),
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/cafe': (context) => const CafePage(),
        '/menu': (context) => const MenuPage(selectedStore: {}),
        '/forgot-password': (context) => const ForgotPassword(),
        '/order-confirm': (context) => const OrderConfirmationScreen(),
        '/profile': (context) => const ProfilePage(storeAddress: 'No store selected'),
      },
    );
  }
}