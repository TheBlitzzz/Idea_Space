import 'package:flutter/material.dart';

extension WidgetTransforms on Widget {
  /// Wraps the widget with a Positioned widget.
  ///
  /// Offsets from the top left corner.
  /// (Recenter the widget according to size)
  Positioned setSizeAndOffset(Offset offset, Size size) {
    return Positioned(
      width: size.width,
      height: size.height,
      top: offset.dy - (size.height / 2),
      left: offset.dx - (size.width / 2),
      child: this,
    );
  }

  /// Wraps the widget with a Positioned widget.
  Positioned setPosition(Offset offset) {
    return Positioned(
      top: offset.dy,
      left: offset.dx,
      child: this,
    );
  }

  /// Wraps the widget with a SizedBox widget.
  SizedBox setSize(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: this,
    );
  }

  Container setDecoration(Size size, BoxDecoration decoration, {BoxConstraints constraints}) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: decoration,
      constraints: constraints,
      child: this,
    );
  }
}
