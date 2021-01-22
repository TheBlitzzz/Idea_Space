part of mind_map;

class LinkPainter extends CustomPainter {
  final Offset startPos;
  final Offset endPos;

  LinkPainter(this.startPos, this.endPos);

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
      ..strokeWidth = 3
      ..color = _toolOutlineColour;

    canvas.drawLine(startPos, endPos, painter);
  }

  @override
  bool shouldRepaint(LinkPainter oldDelegate) {
    return false;
  }
}
