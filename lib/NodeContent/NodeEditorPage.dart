part of nodes;

class NodeEditorPage extends StatefulWidget {
  final BaseNode node;
  final MindMapEditorState rootMindMap;

  NodeEditorPage(this.node, this.rootMindMap);

  @override
  State<StatefulWidget> createState() {
    return NodeEditorState();
  }
}

class NodeEditorState extends State<NodeEditorPage> {
  final TextEditingController nodeTitleController = TextEditingController();
  final TextEditingController content1Controller = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nodeTitleController.dispose();
    content1Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nodeTitleController.text = widget.node.title;
    nodeTitleController.selection = TextSelection.fromPosition(TextPosition(offset: nodeTitleController.text.length));

    Widget nodeTitleField = TextField(
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.done,
      onChanged: (String value) => setState(() => widget.node.title = value),
      controller: nodeTitleController,
    );

    Widget titleField = TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Title',
        prefixIcon: IconButton(
          icon: Icon(Icons.unfold_more),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.more_horiz),
        ),
      ),
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.done,
    );

    Widget testContentField;
    if (isEditing) {
      testContentField = Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 200),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Content 1',
                prefixIcon: IconButton(
                  icon: Icon(Icons.unfold_more),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () => setState(() => isEditing = !isEditing),
                ),
              ),
              autocorrect: true,
              enableSuggestions: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.done,
              controller: content1Controller,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add),
              ),
              IconButton(
                icon: Icon(Icons.copy),
              ),
              IconButton(
                icon: Icon(Icons.bookmark),
              ),
              IconButton(
                icon: Icon(Icons.delete),
              ),
            ],
          )
        ],
      );
    } else {
      testContentField = TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Content 1',
          prefixIcon: IconButton(
            icon: Icon(Icons.unfold_more),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ),
        autocorrect: true,
        enableSuggestions: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        textInputAction: TextInputAction.done,
        controller: content1Controller,
      );
    }

    Widget contentField = TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Content 2',
        prefixIcon: IconButton(
          icon: Icon(Icons.unfold_more),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.more_horiz),
        ),
      ),
      autocorrect: true,
      enableSuggestions: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.done,
    );

    Widget spacing = SizedBox(height: 20);

    Widget list = ListView(
      children: [
        spacing,
        titleField,
        spacing,
        testContentField,
        spacing,
        contentField,
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(left: 80, right: 80),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Icon(Icons.add),
            onPressed: () => debugPrint("Adding content"),
          ),
        ),
      ],
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: nodeTitleField,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: backToMindMap,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () => debugPrint("UNDOING"),
            ),
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: () => debugPrint("REDOING"),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
          ],
          backgroundColor: Colors.blueGrey[800],
        ),
        body: Center(
          child: list,
        ),
      ),
    );
  }

  void backToMindMap() {
    widget.rootMindMap.selectNode((widget.node.id));
    widget.rootMindMap.deselectActiveSelection();
    Navigator.of(context).pop();
  }

  void refresh() {
    setState(() {});
  }
}
