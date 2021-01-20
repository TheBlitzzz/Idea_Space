part of mind_map;

class _NodeToolStack extends StatelessWidget {
  static const double _outlineWidth = 3, _dotAndLineWidth = 20, _dotSize = _outlineWidth * 3, _buttonSpacing = 10;

  final BaseNodeModel node;
  final bool isSelected;

  _NodeToolStack(this.node) : this.isSelected = node != null;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.add(_createAnimLine());
    children.add(_createAnimDot());

    children.add(_createNodeToolButton(0, Icons.edit, () => _editNode(context)));
    children.add(_createNodeToolButton(1, Icons.link, () => debugPrint("Linking")));
    children.add(_createNodeToolButton(2, Icons.delete, () => debugPrint("Delete")));

    Offset toolPos = isSelected ? node.getPosition + Offset(0, node.height) : Offset.zero;
    return Positioned(
      child: Stack(
        children: children,
      ),
      top: toolPos.dy,
      left: toolPos.dx,
      width: (_buttonSize * 3) + (_buttonSpacing * 2) + _dotAndLineWidth,
      height: _buttonSpacing + _buttonSize,
    );
  }

  //region UI

  Widget _createNodeToolButton(int leftIndent, IconData icon, Function() onPressed) {
    var borderRadius = BorderRadius.circular(_borderRadius);
    return TweenAnimationBuilder<double>(
      child: Material(
        child: InkWell(child: Icon(icon), onTap: onPressed, borderRadius: borderRadius),
        color: _toolOutlineColour,
        borderRadius: borderRadius,
      ),
      builder: (context, size, child) {
        return Positioned(
          child: child,
          top: _buttonSpacing,
          left: ((_buttonSize + _buttonSpacing) * leftIndent) + _dotAndLineWidth,
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
          left: (_dotAndLineWidth / 2) - (_outlineWidth / 2),
          width: _outlineWidth,
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: 0, end: _buttonSize + (_dotSize / 2)),
    );
  }

  Widget _createAnimDot() {
    return TweenAnimationBuilder<double>(
      builder: (context, size, child) {
        return Positioned(
          child: Container(
            decoration: BoxDecoration(color: _toolOutlineColour, shape: BoxShape.circle),
            width: size,
            height: size,
          ),
          top: _buttonSize,
          left: (_dotAndLineWidth / 2) - (_dotSize / 2),
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: 0, end: _dotSize),
    );
  }

  //endregion
  //endregion

  //region Logic
  void _editNode(BuildContext context) {
    if (isSelected) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NodeEditorContent()));
    }
  }
//endregion
}

class _MindMapToolStack extends StatelessWidget {
  static const double _editorToolLineWidth = 5, _editorToolLength = 150;
  static const Color _editorToolColour = Color(0xFFAAAAAA);

  final Offset position;
  final void Function() onTap;
  final List<void Function()> addFunctions;
  final double _tapMarkerSize;
  final bool isSelected;

  _MindMapToolStack(this.position, this.isSelected, {this.onTap, this.addFunctions, double tapMarkerSize})
      : _tapMarkerSize = tapMarkerSize ?? 30;

  @override
  Widget build(BuildContext context) {
    double dy = position.dy;
    double dx = position.dx - _tapMarkerSize / 2;

    List<Widget> children = [];

    if (isSelected) {
      // Draw the tool box
      dy -= _tapMarkerSize;
      children.add(_createMarker(_tapMarkerSize / 2, 0, _tapMarkerSize));
      children.add(_createToolLine(duration: _animDuration, length: _editorToolLength * (4 / 3)));
      children.add(_createEndDot(isSelected));
      children.add(_createAddButtons(isSelected));
    } else {
      // Just appear
      dy -= _tapMarkerSize / 2;
      children.add(_createMarker(0, 0, _tapMarkerSize));
      children.add(_createToolLine());
      children.add(_createEndDot(isSelected));
      children.add(_createAddButtons(isSelected));
    }

    return Positioned(
      child: Stack(children: children),
      top: dy,
      left: dx,
      width: _tapMarkerSize * (isSelected ? 2 : 1),
      height: _tapMarkerSize * (isSelected ? 2 : 1) + (isSelected ? _editorToolLength : 0),
    );
  }

  //region UI
  Widget _createMarker(double dy, double startSize, double endSize) {
    return TweenAnimationBuilder<double>(
      child: Container(
        child: InkWell(onTap: onTap),
        decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
      ),
      builder: (context, size, child) {
        return Positioned(
          child: child,
          top: (_tapMarkerSize / 2) + dy - (size / 2),
          left: (_tapMarkerSize / 2) - (size / 2),
          width: size,
          height: size,
        );
      },
      duration: _animDuration,
      tween: Tween<double>(begin: startSize, end: endSize),
    );
  }

  Widget _createAddButtons(bool state) {
    return Positioned(
      child: AnimatedContainer(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _createAddButton(state, Icons.add, null, addFunctions[0]),
              _createAddButton(state, Icons.text_fields_outlined, Color(0x44FFFFFF), addFunctions[1]),
              _createAddButton(state, Icons.image_outlined, null, addFunctions[2]),
            ],
          ),
        ),
        duration: state ? _animDuration : Duration.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF002244),
          border: Border.all(color: _editorToolColour, width: _editorToolLineWidth / 2),
        ),
        height: _tapMarkerSize * 2,
        width: state ? _editorToolLength : 0,
      ),
      top: position.dy - _tapMarkerSize,
      left: position.dx + (_tapMarkerSize / 2) + (_editorToolLength / 6),
    );
  }

  Widget _createToolLine({Duration duration, double length}) {
    return Positioned(
      child: AnimatedContainer(
        duration: duration ?? Duration.zero,
        color: _editorToolColour,
        height: _editorToolLineWidth,
        width: length ?? 0,
      ),
      top: position.dy - _editorToolLineWidth / 2,
      left: position.dx + _tapMarkerSize / 2,
    );
  }

  Widget _createEndDot(bool state) {
    return Positioned(
      top: position.dy - _tapMarkerSize / 4,
      left: position.dx + _tapMarkerSize / 4 + _editorToolLength * (4 / 3),
      child: AnimatedContainer(
        duration: state ? _animDuration : Duration.zero,
        decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
        height: _tapMarkerSize / 2,
        width: state ? _tapMarkerSize / 2 : 0,
      ),
    );
  }

  Widget _createAddButton(bool state, IconData icon, Color colour, Function() onTap) {
    return AnimatedContainer(
      child: state ? InkWell(onTap: onTap, child: Icon(icon)) : null,
      duration: state ? _animDuration : Duration.zero,
      color: colour,
      height: double.infinity,
      width: state ? _editorToolLength / 3 - 1 : 0,
    );
  }
//endregion
}
