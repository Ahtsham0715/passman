import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:passman/records/record_details_page.dart';
import 'package:passman/res/components/custom_text.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final ScrollController scrollcont = ScrollController();
  ValueNotifier<bool> isScrolling = ValueNotifier(true);
  @override
  void initState() {
    scrollcont.addListener(() {
      if (scrollcont.position.pixels <= 5) {
        isScrolling.value = true;
        // isScrolling.notifyListeners();
      } else {
        isScrolling.value = false;
        // isScrolling.notifyListeners();

      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal.shade100,
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'My Records',
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w500,
              // color: Colors.white,
              fontFamily: 'majalla'),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
          valueListenable: isScrolling,
          builder: (context, scrolling, _) {
            return !scrolling
                ? FloatingActionButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 25.0,
                    ),
                  )
                : FloatingActionButton.extended(
                    onPressed: () {},
                    elevation: 0.0,

                    // shape: scrolling ? null : const CircleBorder(),
                    label: const CustomText(
                        // fontcolor: Colors.white,
                        title: 'Password',
                        fontweight: FontWeight.w500,
                        fontsize: 22.0),
                    backgroundColor: Colors.green,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 25.0,
                    ),
                  );
          }),
      body: ListView.separated(
        controller: scrollcont,
        separatorBuilder: (context, index) {
          return const Divider(
            color: Colors.black,
            thickness: 0.25,
          );
        },
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Get.to(
                () => const RecordDetails(),
              );
            },
            dense: true,
            leading: const Icon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
              size: 40.0,
            ),
            title: const CustomText(
                title: 'Facebook', fontweight: FontWeight.w600, fontsize: 23.0),
            subtitle: const CustomText(
                title: 'shami@gamil.com',
                fontweight: FontWeight.w500,
                fontsize: 20.0),
            trailing: const Icon(
              Icons.copy,
              color: Colors.black54,
              size: 25.0,
            ),
          );
        },
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
