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

    Offset toolPos = isSelected ? node.getPosition + Offset(0, node.size.height) : Offset.zero;
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
