part of mind_map;

class _NodeFactory {
  final Size defaultSize;
  final MindMapModel data;
  final Function(BaseNodeModel) selectFunc;
  final Function(DragStartDetails, BaseNodeModel) nodeTranslationStart;
  final Function(DragUpdateDetails, BaseNodeModel) nodeTranslation;

  BaseNodeModel selectedNode;
  List<BaseNodeModel> nodes;

  _NodeFactory(this.data, this.selectFunc, this.nodeTranslationStart, this.nodeTranslation,
      {this.defaultSize = const Size(120, 40)}) {
    nodes = [];
    nodes.addAll(data.pageNodes);
    nodes.addAll(data.textNodes);
    nodes.addAll(data.imageNodes);
  }

  void addNode(Offset offset, eNodeType type) => nodes.add(data.addNewNode(offset, defaultSize, type));

  // void addTextNode(Offset offset) => data.addTextNode(offset, defaultSize);

  void linkNodes(BaseNodeModel startNode, BaseNodeModel endNode) => data.linkNodes(startNode, endNode);

  void deleteNode(BaseNodeModel node) {
    if (node == null) return;

    nodes.removeAt(_findNodeIndexInList(node.id));

    // //region Removing the link references in the linked nodes
    // var links = node.links;
    // links.forEach((link) {
    //   var linkedNodeId;
    //   if (link.startNodeId == node.id) {
    //     linkedNodeId = link.endNodeId;
    //   } else {
    //     linkedNodeId = link.startNodeId;
    //   }
    //   nodes[_findNodeIndexInList(linkedNodeId)].removeConnection(link.id);
    // });
    //endregion

    data.deleteNode(node);
  }

  int _findNodeIndexInList(int nodeId) {
    if (nodeId == null) return null;
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].id == nodeId) return i;
    }
    return null;
  }

  //region Widgets
  List<Widget> _createNodeWidgets(int selectedIndex) {
    List<Widget> children = [];

    selectedNode = null;
    nodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) selectedNode = element;
      }
      children.add(_wrapNodeWidget(element, isSelected, eNodeType.Page));
    });
    // data.textNodes.forEach((element) {
    //   bool isSelected = false;
    //   if (selectedIndex != null) {
    //     isSelected = selectedIndex == element.id;
    //     if (isSelected == true) {
    //       selectedNode = element;
    //     }
    //   }
    //   children.add(_wrapNodeWidget(element, isSelected, eNodeType.Text));
    // });

    return children;
  }

  Widget _wrapNodeWidget(BaseNodeModel node, bool isSelected, eNodeType type) {
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
//endregion
}

enum eNodeType {
  Page,
  Text,
  Image,
}
