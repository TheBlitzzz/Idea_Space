part of nodes;

abstract class BaseNodeModel {
  int id;
  String title;
  Size size;
  Offset position;

  List<NodeConnection> links;

  BaseNodeModel(this.id, this.title, this.size, this.position) {
    links = [];
  }

  Offset get getPosition {
    return position - Offset(size.width / 2, size.height / 2);
  }

  void addConnection(NodeConnection connection) {
    links.add(connection);
  }

  void removeConnection(NodeConnection connection) {
    links.remove(connection);
  }

  void onDelete(List<BaseNodeModel> nodeList) {
    links.forEach((element) {
      element.onDelete(nodeList);
    });
  }
}

class NodeConnection {
  int startNodeId;
  int endNodeId;

  NodeConnection(this.startNodeId, this.endNodeId);

  void onDelete(List<BaseNodeModel> nodeList) {
    nodeList[startNodeId].removeConnection(this);
    nodeList[endNodeId].removeConnection(this);
  }
}
