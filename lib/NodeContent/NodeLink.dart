part of nodes;

class NodeLink extends StatelessWidget {
  final NodeLinkInfo info;

  NodeLink(this.info);

  @override
  Widget build(BuildContext context) {
    Widget painter = CustomPaint(
      painter: NodeLinkPainter(info.startNode.position, info.endNode.position),
    );

    return painter;
  }
}

class NodeLinkPainter extends CustomPainter {
  final Offset startPos;
  final Offset endPos;

  NodeLinkPainter(this.startPos, this.endPos);

  @override
  void paint(Canvas canvas, Size size) {
    Paint painter = Paint()
      ..strokeWidth = 3
      ..color = Colors.blue[300];
    canvas.drawLine(startPos, endPos, painter);
  }

  @override
  bool shouldRepaint(NodeLinkPainter oldDelegate) {
    return false;
  }
}

class NodeLinkInfo {
  BaseNodeModel startNode;
  BaseNodeModel endNode;

  NodeLinkInfo(this.startNode, this.endNode);
}
