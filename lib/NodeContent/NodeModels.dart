part of nodes;

@JsonSerializable()
class PageNodeModel extends BaseNodeModel {
  String nodeTitle = "Untitled";
  List<String> textBlocks = [];

  @override
  eNodeType get type => eNodeType.Page;

  PageNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Page #$id", width, height, dx, dy);

  // PageNodeModel(int id, double width, double height, double dx, double dy, this.nodeTitle, this.textBlocks)
  //     : super(id, "Page #$id", width, height, dx, dy);

  @override
  void edit(BuildContext context, {void Function() onEndEdit}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NodeEditorContent(this)));
  }

  @override
  Widget createNodeWidget(bool isSelected) {
    return Container(
      child: Text(title).align(Alignment.center),
      decoration: BoxDecoration(
        color: Color(colour),
        borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
      ),
    );
  }

  //region JSON
  factory PageNodeModel.fromJson(Map<String, dynamic> json) => _$PageNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PageNodeModelToJson(this);
//endregion
}

@JsonSerializable()
class TextNodeModel extends BaseNodeModel {
  @override
  eNodeType get type => eNodeType.Text;

  TextNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Text #$id", width, height, dx, dy);

  @override
  void edit(BuildContext context, {void Function() onEndEdit}) {
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
                  title = (newTitle == null || newTitle == "") ? "Untitled" : newTitle;
                  onEndEdit?.call();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    onEndEdit?.call();
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  Widget createNodeWidget(bool isSelected) {
    return Container(
      child: Text(title, softWrap: true, overflow: TextOverflow.ellipsis),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: isSelected ? Color(colour) : null,
        border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
      ),
      alignment: Alignment.center,
    );
  }

  //region JSON
  factory TextNodeModel.fromJson(Map<String, dynamic> json) => _$TextNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextNodeModelToJson(this);
//endregion
}

@JsonSerializable()
class ImageNodeModel extends BaseNodeModel {
  String imageInBase64;

  @override
  eNodeType get type => eNodeType.Image;

  ImageNodeModel(int id, double width, double height, double dx, double dy, this.imageInBase64)
      : super(id, "Image #$id", width, height, dx, dy);

  Future<File> _imgFrom(ImageSource source) async {
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    debugPrint("No image selected or image selected is null");
    return null;
  }

  void editImage(Future<File> file) async {
    imageInBase64 = base64Encode((await file).readAsBytesSync());
  }

  @override
  void edit(BuildContext context, {void Function() onEndEdit}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        editImage(_imgFrom(ImageSource.gallery));
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      editImage(_imgFrom(ImageSource.gallery));
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.cancel_outlined),
                    title: new Text('Cancel'),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget createNodeWidget(bool isSelected) {
    Widget image;
    if (imageInBase64 == "" || imageInBase64 == null) {
      image = Icon(Icons.image_outlined);
    } else {
      image = Image.memory(base64Decode(imageInBase64));
    }

    return Container(
      child: image,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: Color(colour),
        border: isSelected ? Border.all(width: _outlineWidth, color: _toolOutlineColour) : null,
      ),
      alignment: Alignment.center,
    );
  }

  //region JSON
  factory ImageNodeModel.fromJson(Map<String, dynamic> json) => _$ImageNodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageNodeModelToJson(this);
//endregion
}
