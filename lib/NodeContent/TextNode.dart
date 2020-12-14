part of nodes;

class TextNode extends BaseNode {
  String textContent;

  TextNode(int id, Size size, Offset position, bool isSelected)
      : super(id, "Untitled #$id", size, position, isSelected);
}
