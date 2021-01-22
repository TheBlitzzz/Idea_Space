part of nodes;

abstract class BaseNodeModel {
  int id;
  String title;
  double width;
  double height;
  double dx;
  double dy;
  int colour = 0xFF616161;

  List<NodeLinkModel> links;

  BaseNodeModel(this.id, this.title, this.width, this.height, this.dx, this.dy) {
    links = [];
  }

  Offset get getPosition {
    return Offset(dx - width / 2, dy - height / 2);
  }

  eNodeType get type;

  void moveTo(Offset position) {
    dx = position.dx;
    dy = position.dy;
  }

  void addConnection(NodeLinkModel connection) {
    links.add(connection);
  }

  void removeConnection(int linkId) {
    for (int i = 0; i < links.length; i++) {
      if (links[i].id == linkId) {
        links.remove(i);
        return;
      }
    }
    debugPrint("Link not found in node $id");
  }

  // void dispose(List<BaseNodeModel> nodeList) {
  //   _links.forEach((element) {
  //     element.dispose(nodeList);
  //   });
  // }

  void edit(BuildContext context, {void Function() onEndEdit});

  Widget createNodeWidget(bool isSelected);
}

@JsonSerializable()
class NodeLinkModel {
  int id;
  int startNodeId;
  int endNodeId;

  NodeLinkModel(this.id, this.startNodeId, this.endNodeId);

  factory NodeLinkModel.fromJson(Map<String, dynamic> json) => _$NodeLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$NodeLinkModelToJson(this);

// void dispose(List<BaseNodeModel> nodeList) {
//   nodeList[startNodeId].removeConnection(this);
//   nodeList[endNodeId].removeConnection(this);
// }
}
