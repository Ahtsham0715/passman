import 'package:flutter/material.dart';

//Copy this CustomPainter code to the Bottom of the File
class CustomLoginShape extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
Path path_0 = Path();
    path_0.moveTo(size.width*0.03482587,size.height*0.05632184);
    path_0.cubicTo(size.width*0.03482587,size.height*0.03156425,size.width*0.07826095,size.height*0.01149425,size.width*0.1318408,size.height*0.01149425);
    path_0.lineTo(size.width*0.8681592,size.height*0.01149425);
    path_0.cubicTo(size.width*0.9217388,size.height*0.01149425,size.width*0.9651741,size.height*0.03156425,size.width*0.9651741,size.height*0.05632184);
    path_0.lineTo(size.width*0.9651741,size.height*0.4361057);
    path_0.cubicTo(size.width*0.9651741,size.height*0.4539368,size.width*0.9423035,size.height*0.4700724,size.width*0.9069279,size.height*0.4771977);
    path_0.lineTo(size.width*0.03482587,size.height*0.6528736);
    path_0.lineTo(size.width*0.03482587,size.height*0.05632184);
    path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Colors.white.withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.9651741,size.height*0.9344828);
    path_1.cubicTo(size.width*0.9651741,size.height*0.9592402,size.width*0.9217388,size.height*0.9793103,size.width*0.8681592,size.height*0.9793103);
    path_1.lineTo(size.width*0.1318408,size.height*0.9793103);
    path_1.cubicTo(size.width*0.07826095,size.height*0.9793103,size.width*0.03482587,size.height*0.9592402,size.width*0.03482587,size.height*0.9344828);
    path_1.lineTo(size.width*0.03482587,size.height*0.7053897);
    path_1.cubicTo(size.width*0.03482587,size.height*0.6872471,size.width*0.05849204,size.height*0.6708931,size.width*0.09477736,size.height*0.6639621);
    path_1.lineTo(size.width*0.9651741,size.height*0.4977011);
    path_1.lineTo(size.width*0.9651741,size.height*0.9344828);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = Colors.white.withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}