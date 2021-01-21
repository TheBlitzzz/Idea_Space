part of mind_map;

class _NodeToolStack extends StatelessWidget {
  static const double _outlineWidth = 3,
      _dotSize = _outlineWidth * 3,
      _buttonSpacing = 10,
      _buttonSizeWithSpacing = _buttonSize + _buttonSpacing;

  final int linesPerRow;
  final int _rowCount;
  final Offset _offset;
  final bool _isSelected;
  final List<ToolAction> _actions;

  _NodeToolStack(this._offset, this._actions, {this.linesPerRow = 3})
      : this._isSelected = _offset != null,
        this._rowCount = (_actions.length / linesPerRow).ceil();

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(_createAnimLine());

    for (int i = 0; i < _rowCount; i++) {
      children.add(_createAnimDot(i));
    }

    for (int i = 0; i < _actions.length; i++) {
      var action = _actions[i];
      children.add(_createNodeToolButton(i, action.icon, action.onTap));
    }

    Offset toolPos = _isSelected ? _offset : Offset.zero;
    return Positioned(
      child: Stack(
        children: children,
      ),
      top: toolPos.dy,
      left: toolPos.dx - (_dotSize / 2),
      width: (_buttonSizeWithSpacing * 3) + _buttonSpacing,
      height: (_buttonSizeWithSpacing) * _rowCount,
    );
  }

  //region UI
  Widget _createNodeToolButton(int index, IconData icon, Function() onPressed) {
    var borderRadius = BorderRadius.circular(_borderRadius);
    int row = index ~/ 3;
    int leftIndent = index % 3;
    return TweenAnimationBuilder<double>(
      builder: (context, size, child) {
        return Positioned(
          child: Material(
            child: InkWell(child: Icon(icon, size: size * 0.75), onTap: onPressed, borderRadius: borderRadius),
            color: _toolOutlineColour,
            borderRadius: borderRadius,
          ),
          top: (_buttonSizeWithSpacing * row) + _buttonSpacing,
          left: (_buttonSizeWithSpacing * leftIndent) + (_buttonSpacing * 2),
          height: size,
          width: _buttonSize,
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: 0, end: _buttonSize),
    );
  }

  //region Dot and line anim
  //The tool stack has a dot and line for decorative purposes.
  Widget _createAnimLine() {
    return TweenAnimationBuilder<double>(
      builder: (context, size, child) {
        return Positioned(
          child: Container(
            decoration: BoxDecoration(color: _toolOutlineColour),
            height: size,
          ),
          left: (_dotSize / 2) - (_outlineWidth / 2),
          width: _outlineWidth,
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: 0, end: _buttonSize + (_dotSize / 2) + (_buttonSizeWithSpacing * (_rowCount - 1))),
    );
  }

  Widget _createAnimDot(int row) {
    return TweenAnimationBuilder<double>(
      builder: (context, size, child) {
        return Positioned(
          child: Container(
            decoration: BoxDecoration(color: _toolOutlineColour, shape: BoxShape.circle),
            width: size,
            height: size,
          ),
          top: _buttonSize + (_buttonSizeWithSpacing * row),
          left: 0,
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: 0, end: _dotSize),
    );
  }

  //endregion
  //endregion
}

class ToolAction {
  final IconData icon;
  final void Function() onTap;

  ToolAction(this.icon, this.onTap);
}

// class _MindMapToolStack extends StatelessWidget {
//   static const double _editorToolLineWidth = 5, _editorToolLength = 150;
//   static const Color _editorToolColour = Color(0xFFAAAAAA);
//
//   final Offset position;
//   final void Function() onTap;
//   final List<void Function()> addFunctions;
//   final double _tapMarkerSize;
//   final bool isSelected;
//
//   _MindMapToolStack(this.position, this.isSelected, {this.onTap, this.addFunctions, double tapMarkerSize})
//       : _tapMarkerSize = tapMarkerSize ?? 30;
//
//   @override
//   Widget build(BuildContext context) {
//     double dy = position.dy;
//     double dx = position.dx - _tapMarkerSize / 2;
//
//     List<Widget> children = [];
//
//     if (isSelected) {
//       // Draw the tool box
//       dy -= _tapMarkerSize;
//       children.add(_createMarker(_tapMarkerSize / 2, 0, _tapMarkerSize));
//       children.add(_createToolLine(duration: _animDuration, length: _editorToolLength * (4 / 3)));
//       children.add(_createEndDot(isSelected));
//       children.add(_createAddButtons(isSelected));
//     } else {
//       // Just appear
//       dy -= _tapMarkerSize / 2;
//       children.add(_createMarker(0, 0, _tapMarkerSize));
//       children.add(_createToolLine());
//       children.add(_createEndDot(isSelected));
//       children.add(_createAddButtons(isSelected));
//     }
//
//     return Positioned(
//       child: Stack(children: children),
//       top: dy,
//       left: dx,
//       width: _tapMarkerSize * (isSelected ? 2 : 1),
//       height: _tapMarkerSize * (isSelected ? 2 : 1) + (isSelected ? _editorToolLength : 0),
//     );
//   }
//
//   //region UI
//   Widget _createMarker(double dy, double startSize, double endSize) {
//     return TweenAnimationBuilder<double>(
//       child: Container(
//         child: InkWell(onTap: onTap),
//         decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
//       ),
//       builder: (context, size, child) {
//         return Positioned(
//           child: child,
//           top: (_tapMarkerSize / 2) + dy - (size / 2),
//           left: (_tapMarkerSize / 2) - (size / 2),
//           width: size,
//           height: size,
//         );
//       },
//       duration: _animDuration,
//       tween: Tween<double>(begin: startSize, end: endSize),
//     );
//   }
//
//   Widget _createAddButtons(bool state) {
//     return Positioned(
//       child: AnimatedContainer(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               _createAddButton(state, Icons.add, null, addFunctions[0]),
//               _createAddButton(state, Icons.text_fields_outlined, Color(0x44FFFFFF), addFunctions[1]),
//               _createAddButton(state, Icons.image_outlined, null, addFunctions[2]),
//             ],
//           ),
//         ),
//         duration: state ? _animDuration : Duration.zero,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Color(0xFF002244),
//           border: Border.all(color: _editorToolColour, width: _editorToolLineWidth / 2),
//         ),
//         height: _tapMarkerSize * 2,
//         width: state ? _editorToolLength : 0,
//       ),
//       top: position.dy - _tapMarkerSize,
//       left: position.dx + (_tapMarkerSize / 2) + (_editorToolLength / 6),
//     );
//   }
//
//   Widget _createToolLine({Duration duration, double length}) {
//     return Positioned(
//       child: AnimatedContainer(
//         duration: duration ?? Duration.zero,
//         color: _editorToolColour,
//         height: _editorToolLineWidth,
//         width: length ?? 0,
//       ),
//       top: position.dy - _editorToolLineWidth / 2,
//       left: position.dx + _tapMarkerSize / 2,
//     );
//   }
//
//   Widget _createEndDot(bool state) {
//     return Positioned(
//       top: position.dy - _tapMarkerSize / 4,
//       left: position.dx + _tapMarkerSize / 4 + _editorToolLength * (4 / 3),
//       child: AnimatedContainer(
//         duration: state ? _animDuration : Duration.zero,
//         decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
//         height: _tapMarkerSize / 2,
//         width: state ? _tapMarkerSize / 2 : 0,
//       ),
//     );
//   }
//
//   Widget _createAddButton(bool state, IconData icon, Color colour, Function() onTap) {
//     return AnimatedContainer(
//       child: state ? InkWell(onTap: onTap, child: Icon(icon)) : null,
//       duration: state ? _animDuration : Duration.zero,
//       color: colour,
//       height: double.infinity,
//       width: state ? _editorToolLength / 3 - 1 : 0,
//     );
//   }
// //endregion
// }
