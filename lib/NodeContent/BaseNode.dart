part of nodes;

abstract class BaseNodeModel {
  int id;
  String title;
  double width;
  double height;
  double dx;
  double dy;
  int colour = 0xFF616161;

  BaseNodeModel(this.id, this.title, this.width, this.height, this.dx, this.dy);

  Offset get getPosition {
    return Offset(dx - width / 2, dy - height / 2);
  }

  eNodeType get type;

  void moveTo(Offset position) {
    dx = position.dx;
    dy = position.dy;
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
  int startNode;
  eNodeType startType;
  int endNode;
  eNodeType endType;

  NodeLinkModel(this.id, this.startNode, this.startType, this.endNode, this.endType);

  factory NodeLinkModel.fromJson(Map<String, dynamic> json) => _$NodeLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$NodeLinkModelToJson(this);
}
