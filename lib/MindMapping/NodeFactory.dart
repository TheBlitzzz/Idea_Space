part of mind_map;

class _NodeFactory {
  final Size _defaultSize = Size(120, 30);
  MindMapModel data;

  BaseNodeModel selectedNode;
  Function(int) selectFunc;

  _NodeFactory(this.selectFunc, this.data);

  void addPageNode(Offset offset) => data.addTextNode(offset, _defaultSize);

  void addTextNode(Offset offset) => data.addTextNode(offset, _defaultSize);

  List<Widget> _createNodeWidgets(int selectedIndex, TextEditingController controller) {
    List<Widget> children = [];

    selectedNode = null;
    data.pageNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) {
          selectedNode = element;
        }
      }
      children.add(_PageNode(element, isSelected, selectFunc));
    });
    data.textNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) {
          selectedNode = element;
          children.add(_TextNode(element, isSelected, selectFunc, controller));
          return;
        }
      }
      children.add(_TextNode(element, isSelected, selectFunc, controller));
    });

    return children;
  }
}
