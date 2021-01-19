part of mind_map;

class MindMapEditor extends StatefulWidget {
  final MindMapFileModel data;
  final void Function(String) renameFunc;

  MindMapEditor(this.data, this.renameFunc);

  @override
  _MindMapEditorState createState() => _MindMapEditorState();
}

class _MindMapEditorState extends State<MindMapEditor> {
  String title;
  _eMindMapEditorState state = _eMindMapEditorState.PanAndZoom;

  @override
  void initState() {
    title = widget.data.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EditableTitle(_editTitle, title),
      ),
      body: _createMindMapViewer(),
    );
  }

  //region UI
  Widget _createMindMapViewer() {
    BoxDecoration boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[Colors.grey[800], Colors.grey[900], Colors.grey[800]],
        stops: <double>[0.0, 0.5, 1.0],
      ),
    );

    return InteractiveViewer(
      minScale: 0.05,
      maxScale: 20,
      constrained: false,
      child: Container(
        height: 3580,
        width: 2480,
        decoration: boxDecoration,
      ),
    );
  }
  //endregion

//region Logic
  void _editTitle(String newTitle) {
    setState(() {
      widget.renameFunc(newTitle);
      title = newTitle;
    });
  }
//endregion
}

enum _eMindMapEditorState {
  PanAndZoom,
  Selecting,
  Linking_first,
  Linking_second,
}
