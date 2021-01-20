part of mind_map;

@JsonSerializable()
class MindMapModel {
  MindMapFileModel fileData;

  int indexCount;

  List<PageNodeModel> pageNodes;
  List<TextNodeModel> textNodes;

  MindMapModel(this.fileData, this.indexCount, this.pageNodes, this.textNodes);

  PageNodeModel addPageNode(Offset offset, Size size) {
    indexCount++;
    var newPage = PageNodeModel(indexCount, size.width, size.height, offset.dx, offset.dy);
    pageNodes.add(newPage);
    return newPage;
  }

  TextNodeModel addTextNode(Offset offset, Size size) {
    indexCount++;
    var newText = TextNodeModel(indexCount, size.width, size.height, offset.dx, offset.dy);
    textNodes.add(newText);
    return newText;
  }

  //region JSON
  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
//endregion
}
