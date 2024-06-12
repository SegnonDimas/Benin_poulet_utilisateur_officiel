import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //BuildContext context;
    var paint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 80);
    path.quadraticBezierTo(size.width / 3.5, 80, size.width / 2.2, 50);
    path.quadraticBezierTo(3 / 4 * size.width, 5, size.width, 25);
    path.lineTo(size.width, size.height * 1.5);
    path.lineTo(0, size.height * 1.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
