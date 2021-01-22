part of mind_map;

@JsonSerializable()
class MindMapModel {
  MindMapFileModel fileData;

  int nodeIndexCount = 0;
  int linkIndexCount = 0;

  List<PageNodeModel> pageNodes = [];
  List<TextNodeModel> textNodes = [];
  List<ImageNodeModel> imageNodes = [];
  List<NodeLinkModel> links = [];

  MindMapModel(this.fileData);

  void save() {
    String data = jsonEncode(this);
    writeFile(data, [fileData.username], fileData.fileName);
  }

  BaseNodeModel addNewNode(Offset offset, Size size, eNodeType type) {
    nodeIndexCount++;
    BaseNodeModel newNode;
    switch (type) {
      case eNodeType.Page:
        newNode = PageNodeModel(nodeIndexCount, size.width, size.height, offset.dx, offset.dy);
        pageNodes.add(newNode);
        break;
      case eNodeType.Text:
        newNode = TextNodeModel(nodeIndexCount, size.width, size.height, offset.dx, offset.dy);
        textNodes.add(newNode);
        break;
      case eNodeType.Image:
        newNode = ImageNodeModel(nodeIndexCount, size.width, size.height, offset.dx, offset.dy, "");
        imageNodes.add(newNode);
        break;
    }
    save();
    return newNode;
  }

  // TextNodeModel addTextNode(Offset offset, Size size) {
  //   nodeIndexCount++;
  //   var newText = TextNodeModel(nodeIndexCount, size.width, size.height, offset.dx, offset.dy);
  //   textNodes.add(newText);
  //   save();
  //   return newText;
  // }
  void linkNodes(BaseNodeModel startNode, BaseNodeModel endNode) {
    linkIndexCount++;
    var newLink = NodeLinkModel(linkIndexCount, startNode.id, endNode.id);
    startNode.addConnection(newLink);
    endNode.addConnection(newLink);
    links.add(newLink);
    save();
  }

  //region JSON
  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
//endregion
}
