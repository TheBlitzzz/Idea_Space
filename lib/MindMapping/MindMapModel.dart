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

  void linkNodes(BaseNodeModel startNode, BaseNodeModel endNode) {
    linkIndexCount++;
    var newLink = NodeLinkModel(linkIndexCount, startNode.id, endNode.id);
    startNode.addConnection(newLink);
    endNode.addConnection(newLink);
    links.add(newLink);
    save();
  }

  void deleteNode(BaseNodeModel node) {
    switch (node.type) {
      case eNodeType.Page:
        for (int i = 0; i < pageNodes.length; i++) {
          if (pageNodes[i].id == node.id) pageNodes.removeAt(i);
        }
        break;
      case eNodeType.Text:
        for (int i = 0; i < textNodes.length; i++) {
          if (textNodes[i].id == node.id) textNodes.removeAt(i);
        }
        break;
      case eNodeType.Image:
        for (int i = 0; i < imageNodes.length; i++) {
          if (imageNodes[i].id == node.id) imageNodes.removeAt(i);
        }
        break;
    }

    var links = node.links;
    links.forEach((link) {
      int otherNodeId;
      if (node.id == link.startNodeId) {
        otherNodeId = link.endNodeId;
      } else {
        otherNodeId = link.startNodeId;
      }

      for (int i = 0; i < pageNodes.length; i++) {
        if (pageNodes[i].id == otherNodeId) {
          pageNodes[i].removeConnection(link.id);
        }
      }
      for (int i = 0; i < textNodes.length; i++) {
        if (textNodes[i].id == otherNodeId) {
          textNodes[i].removeConnection(link.id);
        }
      }
      for (int i = 0; i < imageNodes.length; i++) {
        if (imageNodes[i].id == otherNodeId) {
          imageNodes[i].removeConnection(link.id);
        }
      }
    });
    save();
  }

  //region JSON
  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
//endregion
}
