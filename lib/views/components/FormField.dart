
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key, required this.controller, required this.keyBoardType, required this.obscureText, required this.hintText, required this.labelText, required this.prefixIcon
  });

  final TextEditingController controller;
  final TextInputType keyBoardType;
  final bool obscureText;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14)

          )
      ),
    );
  }
}
