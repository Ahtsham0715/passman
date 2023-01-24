import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxInt lastPage = 0.obs;
  final PageController pageController = PageController();

  List<dynamic> splashInfo = <Object>[
    {
      "title": 'Secure Your Passwords',
      "subtitle":
          "Welcome to our PassMan! We'll help you to securely store and manage all your passwords in one place. With our app, you'll never have to worry about forgetting a password again.",
      "imageUrl2": "assets/page1.svg",
    },
    {
      "title": 'Local Storage',
      "subtitle":
          "Our app stores all your password locally in your device, app developer or any other person cannot access your passwords because they are saved on your own device.",
      "imageUrl2": "assets/page3.svg",
    },
    {
      "title": 'Stay Protected',
      "subtitle":
          "We take your security seriously. Our app uses military-grade encryption to keep your passwords safe and secure. Plus, with our biometric login feature, only you can access your passwords. So, you can rest assured that your information is protected.",
      "imageUrl2": "assets/page2.svg",
    },
    // {
    //   "title": AppStrings.splash4Title,
    //   "subtitle": AppStrings.splash4Subtitle,
    //   "imageUrl2": "splash-3-1",
    // },
  ];
}
