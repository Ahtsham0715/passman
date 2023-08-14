import 'package:flutter/material.dart';
import 'package:passman/constants.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
             
              Colors.teal,
              Colors.blueAccent,
              Colors.brown,
             
              Color(0xFFA83279),
              Color(0xFF0B486B),
              Color(0xFF009688),
              Color(0xFFFFEB3B),
             
              Color(0xFFF44336),
              
            ]),
          ),
          // color: Colors.black.withOpacity(0.2),

          child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),),
    );
  }
}
