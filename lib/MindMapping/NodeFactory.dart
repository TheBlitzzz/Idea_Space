part of mind_map;

class _NodeFactory {
  final MindMapModel data;
  final Function(BaseNodeModel) selectFunc;
  final Function(DragStartDetails, BaseNodeModel) nodeTranslationStart;
  final Function(DragUpdateDetails, BaseNodeModel) nodeTranslation;

  BaseNodeModel selectedNode;
  List<LinkedNode> linkedNodes;

  _NodeFactory(
    this.data,
    this.selectFunc,
    this.nodeTranslationStart,
    this.nodeTranslation,
  );

  void addNode(Offset offset, eNodeType type) => data.addNewNode(offset, _defaultNodeSize, type);

  void linkNodes(BaseNodeModel startNode, BaseNodeModel endNode) {
    linkedNodes = null;
    data.linkNodes(startNode, endNode);
  }

  void deleteNode(BaseNodeModel node) {
    if (node == null) return;

    linkedNodes = null;
    data.deleteNode(node);

    var links = data.links;
    List<int> linksToRemove = [];
    for (int i = 0; i < links.length; i++) {
      var link = links[i];
      if (link.startNode == node.id || link.endNode == node.id) linksToRemove.add(link.id);
    }
    linksToRemove.forEach((linkId) => data._removeLink(linkId));
    // try remove in while loop and don't increment when removing
  }

  void _findLinkedNodes() {
    linkedNodes = [];
    data.links.forEach((link) {
      BaseNodeModel start = data.find(link.startNode, link.startType);
      BaseNodeModel end = data.find(link.endNode, link.endType);

      linkedNodes.add(LinkedNode(start, end));
    });
  }

  //region Widgets
  List<Widget> _createNodeWidgets(int selectedIndex) {
    List<Widget> children = [];

    selectedNode = null;
    data.pageNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) selectedNode = element;
      }
      children.add(_wrapNodeWidget(element, isSelected));
    });
    data.textNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) selectedNode = element;
      }
      children.add(_wrapNodeWidget(element, isSelected));
    });
    data.imageNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) selectedNode = element;
      }
      children.add(_wrapNodeWidget(element, isSelected));
    });

    return children;
  }

  Widget _wrapNodeWidget(BaseNodeModel node, bool isSelected) {
    Offset position = node.getPosition;
    Widget child = node.createNodeWidget(isSelected);

    return Positioned(
      child: GestureDetector(
        child: child,
        onTapUp: (details) => selectFunc(node),
        onPanUpdate: (details) => nodeTranslation(details, node),
        onPanStart: (details) => nodeTranslationStart(details, node),
      ),
      top: position.dy,
      left: position.dx,
      width: node.width,
      height: node.height,
    );
  }

  List<Widget> _drawNodeLinks() {
    if (linkedNodes == null) {
      _findLinkedNodes();
    }

    List<Widget> linkWidgets = [];
    linkedNodes.forEach((link) {
      linkWidgets.add(_drawLink(link));
    });

    return linkWidgets;
  }

  Widget _drawLink(LinkedNode link) {
    return CustomPaint(
      painter: LinkPainter(Offset(link.start.dx, link.start.dy), Offset(link.end.dx, link.end.dy)),
    );
  }
//endregion
}

enum eNodeType {
  Page,
  Text,
  Image,
}

class LinkedNode {
  BaseNodeModel start;
  BaseNodeModel end;

  LinkedNode(this.start, this.end);
}
