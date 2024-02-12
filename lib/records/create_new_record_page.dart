import 'package:autofill_service/autofill_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/constants.dart';
import 'package:passman/records/controllers/new_record_controller.dart';
import 'package:passman/records/models/password_model.dart';
import 'package:passman/res/components/custom_formfield.dart';
import 'package:passman/res/components/custom_snackbar.dart';
import 'package:passman/res/components/custom_text.dart';
import 'dart:math' as math;

class CreateRecord extends StatefulWidget {
  final bool edit;
  final PasswordModel passwordData;
  final String passwordIndex;
  const CreateRecord(
      {super.key,
      this.edit = false,
      required this.passwordData,
      this.passwordIndex = ''});

  @override
  State<CreateRecord> createState() => _CreateRecordState();
}

class _CreateRecordState extends State<CreateRecord>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _login = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _websiteaddress = TextEditingController();
  TextEditingController _notes = TextEditingController();
  int repeats = 0;

  bool passwordVisible = true;
  // Visibility of password
  void _passwordVisibility() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    super.initState();

    _login.text = widget.passwordData.login.toString();
    _password.text = widget.passwordData.password.toString();
    _websiteaddress.text = widget.passwordData.website.toString();
    _notes.text = widget.passwordData.notes.toString();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NewRecordController recordcontroller = Get.put(NewRecordController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: CustomText(
          title: widget.edit ? 'Update Record' : 'Create New Record',
          fontsize: 30.0,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFFd66d75),
                Color(0XFFe29587),
              ],
              begin: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.bottomCenter
                  : Alignment.bottomLeft,
              end: MediaQuery.of(context).orientation == Orientation.portrait
                  ? Alignment.topCenter
                  : Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () async {
                if (_formkey.currentState!.validate()) {
                  var loginencrypt =
                      encrypter.encrypt(_login.text.toString().trim(), iv: iv);
                  var passwordencrypt =
                      encrypter.encrypt(_password.text.toString(), iv: iv);
                  PasswordModel passworddata = PasswordModel(
                    title: _title.text.toString(),
                    login: loginencrypt.base64,
                    password: passwordencrypt.base64,
                    website: _websiteaddress.text.toString(),
                    notes: _notes.text.toString(),
                    length: _password.text.length,
                  );
                  String randomKey = recordcontroller.generateHiveKey();

                  if (passwordbox.containsKey(randomKey)) {
                    randomKey = recordcontroller.generateHiveKey();
                  } else {}
                  //  final response = await AutofillService().resultWithDataset(
                  //   label: _title.text.toString(),
                  //   username: 'shami@gmail.com',
                  //   password: 'shami123',
                  // );
                  // print('resultWithDataset $response');
                  try {
                    await widget.edit
                        ? passwordbox.put(widget.passwordIndex, passworddata)
                        : passwordbox.put(randomKey.toString(), passworddata);
                    Get.back();
                    if (widget.edit) {
                      Get.back();
                    }
                    styledsnackbar(
                        txt: widget.edit
                            ? 'Password Updated Successfully'
                            : 'Password Saved Successfully',
                        icon: widget.edit ? Icons.update_rounded : Icons.check);
                    _title.clear();
                    _login.clear();
                    _password.clear();
                    _websiteaddress.clear();
                    _notes.clear();
                  } catch (e) {
                    print(e);
                    styledsnackbar(
                        txt: 'Error Saving Password.Try Again',
                        icon: Icons.error);
                  }
                }
              },
              child: Icon(
                Icons.check,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        // height: height,
        // width: width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0XFFd66d75),
            Color(0XFFe29587),
          ],
        )),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Autocomplete<String>(
                fieldViewBuilder:
                    (context, title, titlefocusNode, onFieldSubmitted) {
                  title.text = widget.passwordData.title.toString();
                  return customTextField(
                    'Title',
                    false,
                    null,
                    title,
                    (val) {
                      if (val!.isEmpty) {
                        return "required";
                      }
                    },
                    (val) {},
                    Get.width * 0.5,
                    Get.height * 0.2,
                    UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    pIcon: Icons.note_alt_outlined,
                    focusnode: titlefocusNode,

                    // onsubmit: (val) {
                    //   _title.text = val;
                    // },
                    onchanged: (val) {
                      _title.text = val;
                    },
                  );
                },
                //       optionsViewBuilder: (context, onSelected, options) {
                //       return  Align(
                //   alignment: Alignment.topLeft,
                //   child: Material(
                //     child: Container(
                //       width: 300,
                //       color: Colors.green.shade500,
                //       child: ListView.builder(
                //         padding: EdgeInsets.all(10.0),
                //         itemCount: options.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           final  option = options.elementAt(index);

                //           return GestureDetector(
                //             onTap: () {
                //               onSelected(option);
                //             },
                //             child: ListTile(
                //               title: Text(option, style: const TextStyle(color: Colors.white)),
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // );
                //       },
                optionsBuilder: (TextEditingValue title) {
                  if (title.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return apps.where((String option) {
                    return option
                        .toLowerCase()
                        .startsWith(title.text.toLowerCase());
                  });
                },

                onSelected: (String selection) {
                  _websiteaddress.clear();

                  _title.text = selection;
                  print(selection);
                  _websiteaddress.text = websites[selection].toString();
                  debugPrint('You just selected $selection');
                  debugPrint('controller value ${_title.text}');
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              customTextField(
                'Login',
                false,
                null,
                _login,
                (val) {
                  if (val!.isEmpty) {
                    return "required";
                  }
                },
                (val) {},
                Get.width * 0.5,
                Get.height * 0.2,
                UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                pIcon: Icons.key,
              ),
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
                      passwordVisible,
                      IconButton(
                        // splashColor: Colors.transparent,
                        icon: Icon(
                          //choose the icon on based of passwordVisibility
                          passwordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white,
                        ),
                        onPressed: _passwordVisibility,
                      ),
                      _password,
                      (val) {
                        if (val!.isEmpty) {
                          return "required";
                        }
                      },
                      (val) {},
                      Get.width * 0.5,
                      Get.height * 0.25,
                      UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      onchanged: (val) {
                        recordcontroller.progressBarValue(val);
                        recordcontroller.update();
                      },
                      pIcon: Icons.security,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onTap:
                            // _animationController.isAnimating
                            //     ? null
                            //     :
                            () {
                          // recordcontroller.alphabets = true;
                          // recordcontroller.numbers = true;
                          // recordcontroller.specialcharacters = true;
                          recordcontroller.autogenerate = true;
                          _animationController.addListener(() {});
                          TickerFuture tickerFuture =
                              _animationController.repeat();
                          tickerFuture.timeout(Duration(milliseconds: 400 * 2),
                              onTimeout: () {
                            _animationController.removeListener(() {});
                            _animationController.forward(from: 0);
                            _animationController.stop(canceled: true);
                            recordcontroller
                                .generatePassword(
                                    length: recordcontroller.characters.toInt(),
                                    alphabets: recordcontroller.alphabets,
                                    numbers: recordcontroller.numbers,
                                    specchar:
                                        recordcontroller.specialcharacters)
                                .then((value) {
                              _animationController.reset();
                              _password.text = value.toString();
                              recordcontroller.update();
                            });
                          });
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
              GetBuilder<NewRecordController>(builder: (controller) {
                return !controller.autogenerate
                    ? Center()
                    : SizedBox(
                        height: height * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    title: 'Number of characters',
                                    fontsize: 20.0,
                                    fontcolor: Colors.white,
                                    fontweight: FontWeight.w500,
                                  ),
                                  CustomText(
                                    title: controller.characters
                                        .toInt()
                                        .toString(),
                                    fontsize: 20.0,
                                    fontcolor: Colors.white,
                                    fontweight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 24.0),
                                ),
                                child: Slider(
                                  value: controller.characters,
                                  onChanged: (val) {
                                    // print(controller.characters.toInt());
                                    if (val > 8) {
                                      // print(val);
                                      controller.characters = val;
                                      controller
                                          .generatePassword(
                                              length: val.toInt(),
                                              alphabets: controller.alphabets,
                                              numbers: controller.numbers,
                                              specchar:
                                                  controller.specialcharacters)
                                          .then((value) {
                                        // _animationController.stop();
                                        _password.text = value.toString();
                                        controller.update();
                                      });
                                      // controller.update();
                                    }
                                  },
                                  min: 1,
                                  max: 99,
                                  activeColor: Colors.amber,
                                  inactiveColor: Colors.white70,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomCircle(
                                      title: 'A-Z',
                                      ontap: () {
                                        controller.alphabets =
                                            !controller.alphabets;

                                        controller
                                            .generatePassword(
                                                length: controller.characters
                                                    .toInt(),
                                                alphabets: controller.alphabets,
                                                numbers: controller.numbers,
                                                specchar: controller
                                                    .specialcharacters)
                                            .then((value) {
                                          // _animationController.stop();
                                          _password.text = value.toString();
                                          controller.update();
                                        });
                                        // controller.update();
                                      },
                                      isenabled: controller.alphabets),
                                  CustomCircle(
                                      title: '0-9',
                                      ontap: () {
                                        controller.numbers =
                                            !controller.numbers;

                                        controller
                                            .generatePassword(
                                                length: controller.characters
                                                    .toInt(),
                                                alphabets: controller.alphabets,
                                                numbers: controller.numbers,
                                                specchar: controller
                                                    .specialcharacters)
                                            .then((value) {
                                          // _animationController.stop();
                                          _password.text = value.toString();
                                          controller.update();
                                        });
                                        // controller.update();
                                      },
                                      isenabled: controller.numbers),
                                  CustomCircle(
                                      title: '!@#',
                                      ontap: () {
                                        controller.specialcharacters =
                                            !controller.specialcharacters;

                                        controller
                                            .generatePassword(
                                                length: controller.characters
                                                    .toInt(),
                                                alphabets: controller.alphabets,
                                                numbers: controller.numbers,
                                                specchar: controller
                                                    .specialcharacters)
                                            .then((value) {
                                          // _animationController.stop();
                                          _password.text = value.toString();
                                          controller.update();
                                        });
                                        // controller.update();
                                      },
                                      isenabled: controller.specialcharacters),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
              }),
              GetBuilder<NewRecordController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 13.0, right: 20.0, top: 5.0, bottom: 5.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    value: controller.progressmodel.value,
                    color: controller.progressmodel.color,
                  ),
                );
              }),
              SizedBox(
                height: 20.0,
              ),
              customTextField(
                'Website Address',
                false,
                null,
                _websiteaddress,
                (val) {
                  if (val!.isEmpty) {
                    return "required";
                  }
                  if (!RegExp(
                          r"(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?")
                      .hasMatch(val)) {
                    return "Please Enter Valid URL";
                  }
                },
                (val) {},
                Get.width * 0.5,
                Get.height * 0.2,
                UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                pIcon: MdiIcons.web,
              ),
              SizedBox(
                height: 10.0,
              ),
              customTextField(
                'Notes',
                false,
                null,
                _notes,
                (val) {
                  if (val!.isEmpty) {
                    return "required";
                  }
                },
                (val) {},
                Get.width * 0.5,
                Get.height * 0.2,
                UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                pIcon: Icons.note_add_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircle extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool isenabled;
  const CustomCircle(
      {super.key,
      required this.title,
      required this.ontap,
      required this.isenabled});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isenabled ? Colors.green : Colors.transparent,
          border: Border.all(
            color: !isenabled ? Colors.black : Colors.transparent,
            width: 1.0,
          ),
        ),
        child: CustomText(
          title: title,
          fontsize: 22.0,
          fontcolor: Colors.white,
          fontweight: FontWeight.w500,
        ),
      ),
    );
  }
}
