part of nodes;

abstract class BaseNodeModel {
  int id;
  String title;
  double width;
  double height;
  double dx;
  double dy;

  List<NodeLinkModel> links;

  BaseNodeModel(this.id, this.title, this.width, this.height, this.dx, this.dy) {
    links = [];
  }

  Offset get getPosition {
    return Offset(dx - width / 2, dy - height / 2);
  }

  void addConnection(NodeLinkModel connection) {
    links.add(connection);
  }

  void removeConnection(NodeLinkModel connection) {
    links.remove(connection);
  }

  void onDelete(List<BaseNodeModel> nodeList) {
    links.forEach((element) {
      element.onDelete(nodeList);
    });
  }
}

@JsonSerializable()
class NodeLinkModel {
  int startNodeId;
  int endNodeId;

  NodeLinkModel(this.startNodeId, this.endNodeId);

  factory NodeLinkModel.fromJson(Map<String, dynamic> json) => _$NodeLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$NodeLinkModelToJson(this);

  void onDelete(List<BaseNodeModel> nodeList) {
    nodeList[startNodeId].removeConnection(this);
    nodeList[endNodeId].removeConnection(this);
  }
}
