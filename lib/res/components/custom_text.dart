import 'package:flutter/material.dart';
import 'package:passman/res/extensions.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color fontcolor;
  final FontWeight fontweight;
  final double fontsize;
  final bool underline;
  final TextAlign align;
  const CustomText({
    super.key,
    required this.title,
    this.fontcolor = Colors.black,
    this.fontweight = FontWeight.normal,
    this.fontsize = 17.0,
    this.underline = false,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toString(),
      textAlign: align,
      style: TextStyle(
        fontWeight: fontweight,
        color: fontcolor,
        fontSize: fontsize * context.textScaleFactorResponsive,
        textBaseline: TextBaseline.alphabetic,
        fontFamily: 'majalla',
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}
