import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildTheme() => _buildFrom(ColorScheme.fromSeed(
      seedColor: const Color(0xFF3067DE),
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    ));

ThemeData buildDarkTheme() => _buildFrom(ColorScheme.fromSeed(
      seedColor: const Color(0xFF3067DE),
      brightness: Brightness.dark,
      dynamicSchemeVariant: DynamicSchemeVariant.expressive,
    ));

ThemeData _buildFrom(ColorScheme cs) {
  final base = cs.brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
  final tt = GoogleFonts.poppinsTextTheme(base.textTheme);
  return base.copyWith(
    colorScheme: cs,
    textTheme: tt.copyWith(
      headlineMedium: tt.headlineMedium?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      titleMedium: tt.titleMedium?.copyWith(fontSize: 18),
      bodyLarge: tt.bodyLarge?.copyWith(fontSize: 17),
    ),
    iconTheme: IconThemeData(color: cs.primary, size: 24),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.primary.withValues(alpha: 0.1),
      hintStyle: TextStyle(color: cs.primary.withValues(alpha: 0.7)),
      prefixIconColor: cs.primary.withValues(alpha: 0.7),
      suffixIconColor: cs.primary.withValues(alpha: 0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(20),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cs.primary, width: 1.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: cs.primary, padding: const EdgeInsets.all(8)),
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness:
            cs.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    ),
  );
}
