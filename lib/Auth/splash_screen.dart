import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passman/Auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            // opacity: _animation,
            child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 5.0,
                ),
                child: Image.asset('assets/icon.png')),
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.horizontal,
            child: Text(
              'Secure your passwords secure your life',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'majalla',
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.05,
          ),
        ],
      ),
    );
  }
}
