import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Text at the top
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.06),
                    child: Text(
                      "Magic Coffee",
                      style: GoogleFonts.pacifico(
                        fontSize: 36,
                        color: colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  // Blue container with rounded top starts here
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: constraints.maxHeight * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/vector.png',
                              height: constraints.maxHeight * 0.15,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: constraints.maxHeight * 0.03),
                            const Text(
                              "Feel yourself like a barista!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Magic coffee on order.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(255, 255, 255, 0.9),
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.04),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                iconSize: 50,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/signin');
                                },
                                style: IconButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                ),
                                icon: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}