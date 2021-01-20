part of mind_map;

class _NodeFactory {
  final double _defaultWidth = 120, _defaultHeight = 30;
  int _indexCount;

  List<PageNodeModel> _pageNodes;
  List<TextNodeModel> _textNodes;

  BaseNodeModel selectedNode;
  Function(int) selectFunc;

  _NodeFactory(this.selectFunc,
      {int pageNodeIdCount, int textNodeIdCount, List<PageNodeModel> pageNodes, List<TextNodeModel> textNodes}) {
    _indexCount = pageNodeIdCount ?? 0;
    _indexCount = textNodeIdCount ?? 0;
    _pageNodes = pageNodes ?? [];
    _textNodes = textNodes ?? [];
  }

  PageNodeModel addPageNode(Offset offset) {
    _indexCount++;
    var newPage = PageNodeModel(_indexCount, _defaultWidth, _defaultHeight, offset.dx, offset.dy);
    _pageNodes.add(newPage);
    return newPage;
  }

  TextNodeModel addTextNode(Offset offset) {
    _indexCount++;
    var newText = TextNodeModel(_indexCount, _defaultWidth, _defaultHeight, offset.dx, offset.dy);
    _textNodes.add(newText);
    return newText;
  }

  List<Widget> _createNodeWidgets(int selectedIndex, TextEditingController controller) {
    List<Widget> children = [];

    selectedNode = null;
    _pageNodes.forEach((element) {
      bool isSelected = false;
      if (selectedIndex != null) {
        isSelected = selectedIndex == element.id;
        if (isSelected == true) {
          selectedNode = element;
        }
      }
      children.add(_PageNode(element, isSelected, selectFunc));
    });
    _textNodes.forEach((element) {
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
