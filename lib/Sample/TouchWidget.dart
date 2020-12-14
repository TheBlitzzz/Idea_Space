import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyWidgetState();
  }
}

class MyWidgetState extends State<MyWidget> {
  double posx = 100.0;
  double posy = 100.0;

  void onTapDown(BuildContext context, DragUpdateDetails details) {
    print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        // Hack to expand stack to fill all the space. There must be a better
        // way to do it.
        new Container(color: Colors.white),
        new Positioned(
          child: new Text('hello'),
          left: posx,
          top: posy,
        )
      ]),
    );
  }
}
