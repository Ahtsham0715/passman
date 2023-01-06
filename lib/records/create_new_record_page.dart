import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/custom_text.dart';
import 'dart:math' as math;

class CreateRecord extends StatefulWidget {
  const CreateRecord({super.key});

  @override
  State<CreateRecord> createState() => _CreateRecordState();
}

class _CreateRecordState extends State<CreateRecord>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final TextEditingController _title = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _websiteaddress = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          title: 'Create New Record',
          fontsize: 30.0,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.check,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            customTextField('Title', false, null, _title, (val) {}, (val) {},
                Get.width * 0.5, Get.height * 0.9, UnderlineInputBorder()),
            SizedBox(
              height: 5.0,
            ),
            customTextField('Login', false, null, _login, (val) {}, (val) {},
                Get.width * 0.5, Get.height * 0.95, UnderlineInputBorder()),
            SizedBox(
              height: 5.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: Get.width * 0.9,
                  child: customTextField(
                      'Password',
                      false,
                      null,
                      _password,
                      (val) {},
                      (val) {},
                      Get.width * 0.5,
                      Get.height * 0.95,
                      UnderlineInputBorder()),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: _animationController.isAnimating
                          ? null
                          : () {
                              if (_animationController.isAnimating) {
                                _animationController.stop();
                              } else {
                                _animationController.repeat();
                              }
                            },
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value * 3 * math.pi,
                            child: child,
                          );
                        },
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset('assets/dice.png')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 20.0),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                value: 0.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            customTextField(
              'Website Address',
              false,
              null,
              _websiteaddress,
              (val) {},
              (val) {},
              Get.width * 0.5,
              Get.height * 0.95,
              UnderlineInputBorder(),
              pIcon: FontAwesomeIcons.globe,
            ),
            SizedBox(
              height: 10.0,
            ),
            customTextField(
              'Notes',
              false,
              null,
              _notes,
              (val) {},
              (val) {},
              Get.width * 0.5,
              Get.height * 0.95,
              UnderlineInputBorder(),
            ),
          ],
        ),
      ),
    );
  }
}
