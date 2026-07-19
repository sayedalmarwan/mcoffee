import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.06),
                    child: Text(
                      "Magic Coffee",
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 36,
                        color: colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
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
                            Text(
                              "Feel yourself like a barista!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Magic coffee on order.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onPrimary.withValues(alpha: 0.9),
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.04),
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.shadow.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                iconSize: 50,
                                onPressed: () => Navigator.pushNamed(context, '/signin'),
                                style: IconButton.styleFrom(padding: const EdgeInsets.all(16)),
                                icon: Icon(Icons.arrow_forward_rounded, color: colorScheme.primary),
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
