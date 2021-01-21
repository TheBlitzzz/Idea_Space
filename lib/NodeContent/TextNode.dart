part of nodes;

@JsonSerializable()
class TextNodeModel extends BaseNodeModel {
  String textContent;

  TextNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Untitled #$id", width, height, dx, dy);

  @override
  void edit(BuildContext context) {
    String newTitle;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Text"),
            content: Container(
              child: TextField(
                maxLines: null,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                onChanged: (value) => newTitle = value,
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  title = newTitle;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  //region JSON
  factory TextNodeModel.fromJson(Map<String, dynamic> json) => _$TextNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextNodeModelToJson(this);
//endregion
}

@JsonSerializable()
class PageNodeModel extends BaseNodeModel {
  String nodeTitle;
  List<String> textBlocks;

  PageNodeModel(int id, double width, double height, double dx, double dy, this.nodeTitle, this.textBlocks)
      : super(id, "Untitled #$id", width, height, dx, dy);

  @override
  void edit(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NodeEditorContent(this)));
  }

  //region JSON
  factory PageNodeModel.fromJson(Map<String, dynamic> json) => _$PageNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageNodeModelToJson(this);
//endregion
}
