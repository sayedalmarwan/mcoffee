import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWithSwipeBack extends StatelessWidget {
  final Widget child;

  const AppWithSwipeBack({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Detect swipe from left to right
        if (details.primaryDelta! > 20) {
          Navigator.of(context).maybePop();
        }
      },
      child: child,
    );
  }
}

ThemeData buildTheme() {
  const primary = Color.fromARGB(255, 48, 103, 222);
  final textTheme = GoogleFonts.poppinsTextTheme();

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
    ),
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
    textTheme: textTheme.copyWith(
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primary,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(
        fontSize: 18,
        color: Colors.grey[600],
      ),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontSize: 17,
        color: primary,
      ),
    ),
    iconTheme: const IconThemeData(
      color: primary,
      size: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primary.withValues(alpha: 0.1),
      hintStyle: TextStyle(color: primary.withValues(alpha: 0.7)),
      prefixIconColor: primary.withValues(alpha: 0.7),
      suffixIconColor: primary.withValues(alpha: 0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(20),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.all(8),
      ),
    ),
  );
}