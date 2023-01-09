import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:passman/constants.dart';
import 'package:passman/res/components/custom_text.dart';

class RecordDetails extends StatefulWidget {
  // final Password password;

  const RecordDetails({Key? key}) : super(key: key);

  @override
  _RecordDetailsState createState() => _RecordDetailsState();
}

class _RecordDetailsState extends State<RecordDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Details'),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0XFFd66d75),
                Color(0XFFe29587),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Color(0XFFd66d75),
            Color(0XFFe29587),
          ],
        )),
        child: FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTile(title: 'Facebook', icon: Icons.note_alt_sharp),
                CustomDivider(),
                CustomTile(title: 'https://facebook.com', icon: MdiIcons.web),
                CustomDivider(),
                CustomTile(title: 'shami@gmail.com', icon: MdiIcons.key),
                CustomDivider(),
                ListTile(
                  title: CustomText(
                      // fontcolor: Colors.white,
                      title: '1234***',
                      fontweight: FontWeight.w500,
                      fontsize: 25.0),
                  trailing: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.copy_rounded,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  //  ),
                ),
                CustomDivider(),
                CustomTile(
                    title: 'my facebook password', icon: MdiIcons.noteEdit),
                CustomDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final IconData icon;
  const CustomTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25.0,
        color: Colors.white,
      ),
      title: CustomText(
          fontcolor: Colors.white,
          title: title,
          fontweight: FontWeight.w500,
          fontsize: 22.0),
      //  ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white,
      thickness: 1.0,
      indent: width * 0.15,
      endIndent: 0,
    );
  }
}
