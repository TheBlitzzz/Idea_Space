part of mind_map;

class EditorToolsPainter extends CustomPainter {
  final double strokeWidth;

  EditorToolsPainter(this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.blue[100];

    Rect arcRect = Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height), paint);
    // double segmentOffset = 0.5;
    // double arcSweepRadians = pi * 2 / 3 - segmentOffset * 2;
    // double startAngle = pi / 6;
    // double angleIncrement = pi / 3 * 2;
    // for (int i = 0; i < 3; i++) {
    //   canvas.drawArc(arcRect, startAngle + (angleIncrement * i) + segmentOffset, arcSweepRadians, false, paint);
    // }
  }

  @override
  bool shouldRepaint(EditorToolsPainter oldDelegate) {
    return false;
  }
}
