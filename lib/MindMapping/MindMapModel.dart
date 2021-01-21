part of mind_map;

@JsonSerializable()
class MindMapModel {
  MindMapFileModel fileData;

  int indexCount;

  List<PageNodeModel> pageNodes;
  List<TextNodeModel> textNodes;

  MindMapModel(this.fileData, this.indexCount, this.pageNodes, this.textNodes);

  void save() {
    String data = jsonEncode(this);
    writeFile(data, [fileData.username], fileData.fileName);
  }

  PageNodeModel addPageNode(Offset offset, Size size) {
    indexCount++;
    var newPage = PageNodeModel(indexCount, size.width, size.height, offset.dx, offset.dy, "Untitled", []);
    pageNodes.add(newPage);
    save();
    return newPage;
  }

  TextNodeModel addTextNode(Offset offset, Size size) {
    indexCount++;
    var newText = TextNodeModel(indexCount, size.width, size.height, offset.dx, offset.dy);
    textNodes.add(newText);
    save();
    return newText;
  }

  //region JSON
  factory MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);
  Map<String, dynamic> toJson() => _$MindMapModelToJson(this);
//endregion
}
