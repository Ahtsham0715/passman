import 'package:flutter/gestures.dart';
import'package:flutter/material.dart';
import 'package:passman/constants.dart';
import 'package:passman/widgets/custom_shape.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>   with SingleTickerProviderStateMixin{
 late TabController _tabcontroller;

 @override

  void initState() {
    _tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.only(top: 15.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: //Add this CustomPaint widget to the Widget Tree
Column(
  children: [
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
    ),
  const Padding(
    padding: EdgeInsets.symmetric(vertical: 20.0),
    child:  Text('Login',
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w400,
      ),),
  ),
    RichText(
      textAlign: TextAlign.center,
      text:  TextSpan(
      children: [
        const TextSpan(
          text: 'By signing in you are agreeing\n\nour ',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black
          )
        ),
        TextSpan(
          text: 'Term and privacy policy',
          recognizer: TapGestureRecognizer()..onTap = () {
          print('object');
        },
          style: const TextStyle(
            fontSize: 16.0,
            color: Color(0xFF036BB9)
          )
        ),
      ]
    ),
    ),
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.025,
    ),
    TabBar(
      controller: _tabcontroller,
      isScrollable: true,
      tabs: [
        TextButton(
          onPressed: (){},
          child: const Text('Login',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w400,
        color: Color(0xFF036BB9)
      ),),
        ),
        TextButton(
          onPressed: (){},
          child: const Text('Register',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.w400,
        color: Color(0xFF036BB9)
      ),),
        ),
      ],
    ),
    SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width *0.9,
      child: TabBarView(
        controller: _tabcontroller,
        children: [
          Text('tab1'),
          Text('tab2'),
        ],
      ),
    ),
    // ButtonBar(
    //   alignment: MainAxisAlignment.center,

    //   children: [
    //     TextButton(
    //       onPressed: (){},
    //       child: const Text('Login',
    //   style: TextStyle(
    //     fontSize: 22.0,
    //     fontWeight: FontWeight.w400,
    //     color: Color(0xFF036BB9)
    //   ),),
    //     ),
    //     TextButton(
    //       onPressed: (){},
    //       child: const Text('Register',
    //   style: TextStyle(
    //     fontSize: 22.0,
    //     fontWeight: FontWeight.w400,
    //     color: Color(0xFF036BB9)
    //   ),),
    //     ),
    //   ],
    // ),
  ],
),
      ),
    );
  }
}