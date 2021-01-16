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
  Widget wrapPositioned(double dx, double dy) => Positioned(top: dy, left: dx, child: this);

  /// Wraps the widget with a Positioned widget.
  Widget setPosition(Offset offset) => this.wrapPositioned(offset.dx, offset.dy);

  /// Wraps the widget with a SizedBox widget.
  Widget wrapSized(double width, double height) => SizedBox(width: width, height: height, child: this);

  /// Wraps the widget with a SizedBox widget.
  Widget setSize(Size size) => SizedBox(width: size.width, height: size.height, child: this);

  Widget setDecoration(Size size, BoxDecoration decoration, {BoxConstraints constraints}) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: decoration,
      constraints: constraints,
      child: this,
    );
  }

  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  /// Wraps the widget with a padding widget with an EdgeInsets.all() padding.
  Widget pad(double left, double right, double top, double bottom) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: this,
    );
  }
}
