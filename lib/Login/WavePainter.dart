part of login;

class WavePainter extends CustomPainter {
  final Animation animation;
  final int curveSegments = 10;

  List<CurvePoint> _currentTopCurve = List();
  List<CurvePoint> _currentBottomCurve = List();
  List<CurvePoint> _targetTopCurve = List();
  List<CurvePoint> _targetBottomCurve = List();

  bool isReversed = false;

  WavePainter(this.animation) : super(repaint: animation) {
    for (int i = 0; i < curveSegments; i++) {
      _currentTopCurve.add(CurvePoint(0, 0));
      _currentBottomCurve.add(CurvePoint(0, 0));

      _targetTopCurve.add(CurvePoint(0, 0));
      _targetBottomCurve.add(CurvePoint(0, 0));
    }
    recalcOffsets(AnimationStatus.forward);
  }

  @override
  void paint(Canvas canvas, Size size) {
    double currentVal = isReversed ? 1 - animation.value : animation.value;
    double posXIncrement = size.width / ((curveSegments - 1) * 3);

    Path path = Path();
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(size.width, size.height),
        [Color(0xFFff6347), Color(0xFFffc04a), Color(0xFFff6347)],
        [0.0, 0.5, 1.0],
      );

    // Top curve
    path.moveTo(size.width, 0);
    path.lineTo(0, 0);
    double sizeIncrement = size.width / 100;
    double degreeToRad = (6 * pi) / 100;
    for (int i = 0; i < 101; i++) {
      path.lineTo(i * sizeIncrement, sin(i * degreeToRad) * 50 * currentVal + 100);
    }
    // path.lineTo(0, lerp(_currentTopCurve[0].value, _targetTopCurve[0].value, currentVal) + 100);
    // for (int i = 0; i < curveSegments - 1; i++) {
    //   double lerpVal1 = lerp(_currentTopCurve[i].value, _targetTopCurve[i].value, currentVal) + 100;
    //   double lerpVal2 = lerp(_currentTopCurve[i + 1].value, _targetTopCurve[i + 1].value, currentVal) + 100;
    //   double posXOffset = i * posXIncrement * 3;
    //
    //   path.cubicTo(posXIncrement * 1 + posXOffset, lerpVal1, posXIncrement * 2 + posXOffset, lerpVal2,
    //       posXIncrement * 3 + posXOffset, lerpVal2);
    // }
    canvas.drawPath(path, paint);

    // Bottom curve
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - lerp(_currentBottomCurve[0].value, _targetBottomCurve[0].value, currentVal) - 100);
    for (int i = 0; i < curveSegments - 1; i++) {
      double lerpVal1 = size.height - lerp(_currentBottomCurve[i].value, _targetBottomCurve[i].value, currentVal) - 100;
      double lerpVal2 =
          size.height - lerp(_currentBottomCurve[i + 1].value, _targetBottomCurve[i + 1].value, currentVal) - 100;
      double posXOffset = i * posXIncrement * 3;

      path.cubicTo(posXIncrement * 1 + posXOffset, lerpVal1, posXIncrement * 2 + posXOffset, lerpVal2,
          posXIncrement * 3 + posXOffset, lerpVal2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double lerp(double a, double b, double t) {
    return a + (b - a) * t.clamp(0, 1);
  }

  void recalcOffsets(AnimationStatus status) {
    Random pnrg = Random();
    isReversed = status == AnimationStatus.reverse;
    double sign;
    for (int i = 0; i < curveSegments; i++) {
      _currentTopCurve[i] = _targetTopCurve[i];
      _currentBottomCurve[i] = _targetBottomCurve[i];

      sign = pnrg.nextDouble() > 0.5 ? 1 : -1;
      _targetTopCurve[i] = new CurvePoint(pnrg.nextDouble() * 20 * sign, 0);
      sign = pnrg.nextDouble() > 0.5 ? 1 : -1;
      _targetBottomCurve[i] = new CurvePoint(pnrg.nextDouble() * 20 * sign, 0);
    }
  }
}

class CurvePoint {
  double value;
  double tangent;

  CurvePoint(this.value, this.tangent);

  get inTangent => value - tangent;

  get outTangent => value + tangent;
}
