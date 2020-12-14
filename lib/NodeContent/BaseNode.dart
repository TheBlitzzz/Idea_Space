part of nodes;

abstract class BaseNode {
  int id;
  String title;
  Size size;
  Offset position;
  bool isSelected;

  BaseNode(this.id, this.title, this.size, this.position, this.isSelected);
}
