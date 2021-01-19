part of nodes;

class TextNodeModel extends BaseNodeModel {
  String textContent;

  TextNodeModel(int id, Size size, Offset position) : super(id, "Untitled #$id", size, position);
}

class PageNodeModel extends BaseNodeModel {
  String title;

  PageNodeModel(int id, Size size, Offset position) : super(id, "Untitled #$id", size, position);
}
