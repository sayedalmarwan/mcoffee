import 'package:flutter/material.dart';

class CoffeeField extends StatelessWidget {
  const CoffeeField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 70,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            suffixIcon: suffixIcon,
          ),
        ),
      );
}
