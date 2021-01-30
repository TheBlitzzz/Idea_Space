part of nodes;

@JsonSerializable()
class PageNodeModel extends BaseNodeModel {
  String nodeTitle = "Untitled";
  List<TextBlockModel> textBlocks = [];

  @override
  eNodeType get type => eNodeType.Page;

  PageNodeModel(int id, double width, double height, double dx, double dy)
      : super(id, "Page #$id", width, height, dx, dy);

  //region Text blocks
  void addTextBlock() {
    textBlocks.add(TextBlockModel(""));
  }

  TextBlockModel getTextBlock(int index) => textBlocks[index];

  void moveTextBlockDown(int index) {
    if (index != textBlocks.length - 1) {
      var temp = textBlocks[index + 1];
      textBlocks[index + 1] = textBlocks[index];
      textBlocks[index] = temp;
    } else {
      debugPrint("Can't move the last text block further down!");
    }
  }

  void editTextBlock(int index, TextBlockModel newContent) {
    textBlocks[index] = newContent;
  }

  void deleteTextBlock(int index) {
    textBlocks.removeAt(index);
  }

  //endregion

  @override
  void edit(BuildContext context, {void Function() onEndEdit}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NodeEditorContent(this, onEndEdit)));
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
class TextBlockModel {
  static const List<double> textSizes = [10, 11, 12, 14, 16, 18, 20];

  String content;
  int textSizeIndex;
  bool isUnderlined = false;
  bool isBold = false;
  bool isItalic = false;

  double get getFontSize => textSizes[textSizeIndex];

  TextBlockModel(this.content) {
    textSizeIndex = 2;
  }

  //region JSON
  factory TextBlockModel.fromJson(Map<String, dynamic> json) => _$TextBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextBlockModelToJson(this);
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
              child: TextFormField(
                maxLines: null,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                onChanged: (value) => newTitle = value,
                initialValue: title,
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
      child: Text(
        title,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Color(colour)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: isSelected ? Colors.grey[800] : UserManager.getInstance.thisUser.getColour,
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

  @override
  void edit(BuildContext context, {void Function() onEndEdit}) {
    void editImage(Future<File> file) async {
      imageInBase64 = base64Encode((await file).readAsBytesSync());
      onEndEdit?.call();
    }

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
