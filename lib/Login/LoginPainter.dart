part of login;

class LoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        [Color(0xFFff6347), Color(0xFFffc04a), Color(0xFFff6347)],
        [0.0, 0.5, 1.0],
      );

    // Top curve
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, 100);
    path.cubicTo(size.width / 2, 50, size.width / 8, 150, 0, 350);
    canvas.drawPath(path, paint);

    // Bottom curve
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - 150);
    path.cubicTo(
        size.width / 2, size.height - 100, size.width / 8 * 7, size.height - 150, size.width, size.height - 350);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
