import 'package:flutter/material.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'My Passwords',
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              // color: Colors.white,
              fontFamily: 'majalla'),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
