part of nodes;

class NodeEditorContent extends StatefulWidget {
  final PageNodeModel data;
  final void Function() saveFunc;

  NodeEditorContent(this.data, this.saveFunc);

  @override
  _NodeEditorContentState createState() => _NodeEditorContentState(data.textBlocks.length);
}

class _NodeEditorContentState extends State<NodeEditorContent> with TickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textBlockController = TextEditingController();
  final inputBorder = OutlineInputBorder(
    borderSide: borderSide,
    borderRadius: BorderRadius.circular(_borderRadius),
  );
  static const BorderSide borderSide = BorderSide(color: Colors.blue, width: 2);
  final List<int> textBlockIds;

  int selectedIndex;

  _NodeEditorContentState(int count) : textBlockIds = [] {
    for (int i = 0; i < count; i++) {
      textBlockIds.add(i);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _textBlockController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1B1B2F),
        title: EditableTitle(_editNodeTitle, widget.data.title),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.of(context).pop()),
      ),
      resizeToAvoidBottomInset: true,
      endDrawer: SettingsDrawer(),
      body: Container(
        color: Color(0xff1f4068),
        child: Stack(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  maxLines: 1,
                  style: titleStyle,
                  decoration: InputDecoration(
                    focusedBorder: inputBorder,
                    border: inputBorder,
                    hintText: "Enter a title",
                    hintStyle: titleStyle,
                  ),
                  initialValue: widget.data.nodeTitle,
                  onChanged: _editTitle,
                ),
              ),
              _createTextBlocks(),
            ]),
            _createTextFormatTools(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            widget.data.addTextBlock();
            widget.saveFunc();
            if (textBlockIds.length > 0) {
              textBlockIds.add(textBlockIds[textBlockIds.length - 1] + 1);
            } else {
              textBlockIds.add(1);
            }
          });
        },
      ),
    );
  }

  Widget hidingIcon(TextEditingController controller) {
    if (controller.text != "") {
      return IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => setState(() => controller.clear()),
      );
    } else {
      return null;
    }
  }

  //region UI
  Widget _createTextBlocks() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        itemCount: textBlockIds.length,
        itemBuilder: (context, int i) {
          var textBlock = widget.data.getTextBlock(i);
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: ValueKey(textBlockIds[i]),
            background: Container(
              child: Icon(Icons.delete, size: 30, color: Colors.white).pad(0, 20, 0, 0),
              alignment: AlignmentDirectional.centerEnd,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                color: Colors.red,
              ),
            ),
            onDismissed: (direction) => setState(() {
              widget.data.deleteTextBlock(i);
              textBlockIds.removeAt(i);
              widget.saveFunc();
            }),
            child: GestureDetector(
              child: Container(
                child: Text(
                  textBlock.content,
                  style: TextStyle(
                    fontWeight: textBlock.isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: textBlock.getFontSize,
                    fontStyle: textBlock.isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: textBlock.isUnderlined ? TextDecoration.underline : TextDecoration.none,
                  ),
                ),
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  border: Border.all(color: i == selectedIndex ? Colors.tealAccent : Colors.white),
                  color: Color(0x24FFFFFF),
                ),
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 60),
              ),
              onTap: () {
                setState(() => selectedIndex = i);

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
                            decoration:
                                InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            onChanged: (value) => newTitle = value,
                            initialValue: widget.data.getTextBlock(i).content,
                          ),
                        ),
                        actions: [
                          FlatButton(
                            child: Text('Save'),
                            onPressed: () {
                              setState(() {
                                var textBlock = widget.data.getTextBlock(i);
                                textBlock.content = (newTitle == null || newTitle == "") ? "Untitled" : newTitle;
                                widget.data.editTextBlock(i, textBlock);
                                widget.saveFunc();
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ],
                      );
                    });
              },
            ),
          ).pad(5, 5, 5, 5);
        },
      ),
    );
  }

  Widget _createTextFormatTools() {
    var spacer = SizedBox(width: 10);
    return Container(
      height: 70,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.format_size, color: Colors.black, size: 30),
            onPressed: () => setState(() {
              var textBlock = widget.data.getTextBlock(selectedIndex);
              if (textBlock.textSizeIndex > 0) textBlock.textSizeIndex--;
              widget.data.editTextBlock(selectedIndex, textBlock);
              widget.saveFunc();
            }),
          ),
          spacer,
          IconButton(
            icon: Icon(Icons.format_size, color: Colors.black, size: 40),
            onPressed: () => setState(() {
              var textBlock = widget.data.getTextBlock(selectedIndex);
              if (textBlock.textSizeIndex < 6) textBlock.textSizeIndex++;
              widget.data.editTextBlock(selectedIndex, textBlock);
              widget.saveFunc();
            }),
          ),
          spacer,
          IconButton(
            icon: Icon(Icons.format_bold, color: Colors.black),
            iconSize: 40,
            onPressed: () => setState(() {
              var textBlock = widget.data.getTextBlock(selectedIndex);
              textBlock.isBold = !textBlock.isBold;
              widget.data.editTextBlock(selectedIndex, textBlock);
              widget.saveFunc();
            }),
          ),
          spacer,
          IconButton(
            icon: Icon(Icons.format_underline_outlined, color: Colors.black),
            iconSize: 40,
            onPressed: () => setState(() {
              var textBlock = widget.data.getTextBlock(selectedIndex);
              textBlock.isUnderlined = !textBlock.isUnderlined;
              widget.data.editTextBlock(selectedIndex, textBlock);
              widget.saveFunc();
            }),
          ),
          spacer,
          IconButton(
            icon: Icon(Icons.format_italic, color: Colors.black),
            iconSize: 40,
            onPressed: () => setState(() {
              var textBlock = widget.data.getTextBlock(selectedIndex);
              textBlock.isItalic = !textBlock.isItalic;
              widget.data.editTextBlock(selectedIndex, textBlock);
              widget.saveFunc();
            }),
          ),
        ],
      ),
    ).align(Alignment.bottomCenter);
  }

  Widget _createClearIcon(int index) {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => setState(() {
        var textBlock = widget.data.getTextBlock(index);
        textBlock.content = "";
        widget.data.editTextBlock(index, textBlock);
        widget.saveFunc();
      }),
    );
  }

  //endregion

  //region Logic
  void _editNodeTitle(String newTitle) {
    setState(() {
      widget.data.title = newTitle;
      widget.saveFunc();
    });
  }

  void _editTitle(String newTitle) {
    setState(() {
      widget.data.nodeTitle = newTitle;
      widget.saveFunc();
    });
  }
//endregion
}
