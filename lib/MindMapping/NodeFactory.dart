part of mind_map;

const double _outlineWidth = 3;

class _NodeFactory {
  final Size defaultSize;
  final MindMapModel data;
  final Function(int) selectFunc;
  final Function(DragStartDetails, BaseNodeModel) nodeTranslationStart;
  final Function(DragUpdateDetails, BaseNodeModel) nodeTranslation;
  final Function(DragUpdateDetails, BaseNodeModel, bool, bool) resizeFunc;

  BaseNodeModel selectedNode;

  _NodeFactory(this.data, this.selectFunc, this.nodeTranslationStart, this.nodeTranslation, this.resizeFunc,
      {this.defaultSize = const Size(120, 40)});

  void addPageNode(Offset offset) => data.addPageNode(offset, defaultSize);

  void addTextNode(Offset offset) => data.addTextNode(offset, defaultSize);

  List<Widget> _createNodeWidgets(int selectedIndex, TextEditingController controller) {
    List<Widget> children = [];

    selectedNode = null;
    data.pageNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) selectedNode = element;
      }
      children.add(_wrapNodeWidget(element, isSelected, eNodeType.Page));
    });
    data.textNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) {
          selectedNode = element;
        }
      }
      children.add(_wrapNodeWidget(element, isSelected, eNodeType.Text));
    });

    return children;
  }

  Widget _wrapNodeWidget(BaseNodeModel node, bool isSelected, eNodeType type) {
    Offset position = node.getPosition;
    Widget child;
    switch (type) {
      case eNodeType.Page:
        child = _createPageNode(node.title, isSelected);
        break;
      case eNodeType.Text:
        child = _createTextNode(node.title, isSelected);
        break;
      case eNodeType.Image:
        // TODO: Handle this case.
        break;
    }

    return Positioned(
      child: GestureDetector(
        child: child,
        onTap: () => selectFunc(node.id),
        onPanUpdate: (details) => nodeTranslation(details, node),
        onPanStart: (details) => nodeTranslationStart(details, node),
      ),
      top: position.dy,
      left: position.dx,
      width: node.width,
      height: node.height,
    );
  }

  Widget _createPageNode(String title, bool isSelected) {
    return Container(
      child: Text(title).align(Alignment.center),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
      ),
    );
  }

  Widget _createTextNode(String title, bool isSelected) {
    return Container(
      child: Text(title, softWrap: true, overflow: TextOverflow.ellipsis),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: isSelected ? Colors.grey[600] : null,
        border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
      ),
      alignment: Alignment.center,
    );
  }
}

enum eNodeType {
  Page,
  Text,
  Image,
}
