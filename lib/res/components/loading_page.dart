import 'package:flutter/material.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_text.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        height: height * 0.5,
        width: width * 0.7,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [

        //     Colors.teal,
        //     Colors.blueAccent,
        //     Colors.brown,

        //     Color(0xFFA83279),
        //     Color(0xFF0B486B),
        //     Color(0xFF009688),
        //     Color(0xFFFFEB3B),

        //     Color(0xFFF44336),

        //   ]),
        // ),
        // color: Colors.black.withOpacity(0.2),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            CustomText(title: 'Loading', fontsize: 30, fontcolor: Colors.white),
          ],
        ),
      ),
    );
  }
}
