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
    writeFile(data, [fileData.parentUser], fileData.fileName);
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

  BaseNodeModel find(int id, eNodeType type) {
    switch (type) {
      case eNodeType.Page:
        for (int i = 0; i < pageNodes.length; i++) {
          if (pageNodes[i].id == id) return pageNodes[i];
        }
        break;
      case eNodeType.Text:
        for (int i = 0; i < textNodes.length; i++) {
          if (textNodes[i].id == id) return textNodes[i];
        }
        break;
      case eNodeType.Image:
        for (int i = 0; i < imageNodes.length; i++) {
          if (imageNodes[i].id == id) return imageNodes[i];
        }
        break;
    }
    return null;
  }

  void linkNodes(BaseNodeModel startNode, BaseNodeModel endNode) {
    linkIndexCount++;
    var newLink = NodeLinkModel(linkIndexCount, startNode.id, startNode.type, endNode.id, endNode.type);
    links.add(newLink);
    save();
  }

  void _removeLink(int linkId) {
    for (int i = 0; i < links.length; i++) {
      if (links[i].id == linkId) {
        links.removeAt(i);
        break;
      }
    }
    save();
  }

  void deleteNode(BaseNodeModel node) {
    switch (node.type) {
      case eNodeType.Page:
        pageNodes.remove(node);
        break;
      case eNodeType.Text:
        textNodes.remove(node);
        break;
      case eNodeType.Image:
        imageNodes.remove(node);
        break;
    }
    save();
  }

  //region JSON
  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
//endregion
}
