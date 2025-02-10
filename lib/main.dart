import 'package:dartproyect/views/auth_screen/login_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(StoreApp());

class StoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: LoginScreen(),
    );
  }
}
