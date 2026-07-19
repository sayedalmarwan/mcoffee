import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mcoffee/coffee_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final userId = userCredential.user?.uid;
      if (userId != null) {
        await FirebaseDatabase.instance.ref('users/$userId').set({
          'name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': ServerValue.timestamp,
          'preferredStore': 'No store selected',
        });
      }

      if (mounted) Navigator.pushReplacementNamed(context, '/cafe');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 12),
                  Text("Sign up", style: theme.textTheme.headlineMedium),
                  Text("Create an account", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 24),
                  CoffeeField(
                    controller: _fullNameController,
                    hintText: "Full name",
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your name';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CoffeeField(
                    controller: _emailController,
                    hintText: "Email address",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter your email';
                      if (!value.contains('@')) return 'Please enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CoffeeField(
                    controller: _passwordController,
                    hintText: "Password",
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter a password';
                      if (value.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Center(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: IconButton(
                      iconSize: 50,
                      onPressed: _isLoading ? null : _signUp,
                      icon: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.arrow_forward_rounded),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
