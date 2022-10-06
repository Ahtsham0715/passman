import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class CustomAuthShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.4810456);
    path_0.cubicTo(
        size.width * 0.8892633,
        size.height * 0.5911293,
        size.width * 0.6985628,
        size.height * 0.7034221,
        size.width * 0.4818841,
        size.height * 0.7034221);
    path_0.cubicTo(
        size.width * 0.2872536,
        size.height * 0.7034221,
        size.width * 0.1135838,
        size.height * 0.6128213,
        0,
        size.height * 0.4811179);
    path_0.lineTo(0, size.height * 1.250951);
    path_0.lineTo(size.width, size.height * 1.250951);
    path_0.lineTo(size.width, size.height * 0.4810456);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff469FD1).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
