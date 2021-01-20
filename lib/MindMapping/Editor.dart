part of mind_map;

class Editor extends StatefulWidget {
  final MindMapFileModel data;
  final void Function(String) renameFunc;

  Editor(this.data, this.renameFunc);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  static const double _tapMarkerSize = 30, _editorToolLineWidth = 5, _editorToolLength = 150;
  static const Color _editorToolColour = Color(0xFFAAAAAA);

  final TransformationController _viewerController = new TransformationController();
  final TextEditingController _textNodeEditingController = new TextEditingController();

  // final List<PageNodeModel> pageNodes = [];
  // final List<TextNodeModel> textNodes = [];
  // final Size _defaultNodeSize = Size(120, 40);

  _eMindMapEditorState state = _eMindMapEditorState.PanAndZoom;
  Offset lastTapPos;
  double zoomAmt;

  int selectedNodeIndex;

  _NodeFactory factory;

  _EditorState() {
    factory = new _NodeFactory(_selectNode);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _viewerController.dispose();
    _textNodeEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EditableTitle(_editTitle, widget.data.title),
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

    List<Widget> children = [];

    var nodeWidgets = factory._createNodeWidgets(selectedNodeIndex, _textNodeEditingController);
    if (factory.selectedNode != null) {
      nodeWidgets.add(_NodeToolStack(factory.selectedNode));
    }
    children.add(Stack(children: nodeWidgets));

    if (lastTapPos != null) {
      // tap marker
      children.add(Positioned(
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
          child: InkWell(
            onTap: () => setState(() {
              state = _eMindMapEditorState.Adding;
            }),
          ),
          width: _tapMarkerSize,
          height: _tapMarkerSize,
        ),
        top: lastTapPos.dy - _tapMarkerSize / 2,
        left: lastTapPos.dx - _tapMarkerSize / 2,
      ));

      // line
      children.add(Positioned(
        child: AnimatedContainer(
          duration: state == _eMindMapEditorState.Adding ? _animDuration : Duration.zero,
          color: _editorToolColour,
          height: _editorToolLineWidth,
          width: state == _eMindMapEditorState.Adding ? _editorToolLength * (4 / 3) : 0,
        ),
        top: lastTapPos.dy - _editorToolLineWidth / 2,
        left: lastTapPos.dx + _tapMarkerSize / 2,
      ));

      // Add buttons
      children.add(Positioned(
        child: AnimatedContainer(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _createAddButton(Icons.add, null, _addNode),
                _createAddButton(Icons.text_fields_outlined, Color(0x44FFFFFF), _addText),
                _createAddButton(Icons.image_outlined, null, () {
                  setState(() {
                    state = _eMindMapEditorState.PanAndZoom;
                    lastTapPos = null;
                  });
                  debugPrint("image");
                }),
              ],
            ),
          ),
          duration: state == _eMindMapEditorState.Adding ? _animDuration : Duration.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF002244),
            border: Border.all(color: _editorToolColour, width: _editorToolLineWidth / 2),
          ),
          height: _tapMarkerSize * 2,
          width: state == _eMindMapEditorState.Adding ? _editorToolLength : 0,
        ),
        top: lastTapPos.dy - _tapMarkerSize,
        left: lastTapPos.dx + (_tapMarkerSize / 2) + (_editorToolLength / 6),
      ));

      // Dot
      children.add(Positioned(
        top: lastTapPos.dy - _tapMarkerSize / 4,
        left: lastTapPos.dx + _tapMarkerSize / 4 + _editorToolLength * (4 / 3),
        child: AnimatedContainer(
          duration: state == _eMindMapEditorState.Adding ? _animDuration : Duration.zero,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
          height: _tapMarkerSize / 2,
          width: state == _eMindMapEditorState.Adding ? _tapMarkerSize / 2 : 0,
        ),
      ));
    }

    return InteractiveViewer(
      child: GestureDetector(
        child: Container(
          child: Stack(
            children: children,
          ),
          height: 3580,
          width: 2480,
          decoration: boxDecoration,
        ),
        onTapUp: _onViewerTap,
      ),
      transformationController: _viewerController,
      onInteractionUpdate: (details) {
        zoomAmt = details.scale;
      },
      minScale: 0.05,
      maxScale: 20,
      constrained: false,
    );
  }

  Widget _createAddButton(IconData icon, Color colour, Function() onTap) {
    return AnimatedContainer(
      child: state == _eMindMapEditorState.Adding
          ? InkWell(
              onTap: onTap,
              child: Icon(icon),
            )
          : null,
      duration: state == _eMindMapEditorState.Adding ? _animDuration : Duration.zero,
      color: colour,
      height: double.infinity,
      width: state == _eMindMapEditorState.Adding ? _editorToolLength / 3 - 1 : 0,
    );
  }

  //endregion

//region Logic
  void _editTitle(String newTitle) {
    setState(() {
      widget.renameFunc(newTitle);
    });
  }

  void _onViewerTap(details) {
    setState(() {
      lastTapPos = details.localPosition;
      _deselect();
    });
  }

  void _addNode() {
    factory.addPageNode(lastTapPos);
    setState(() {
      state = _eMindMapEditorState.PanAndZoom;
      lastTapPos = null;
    });
  }

  void _addText() {
    factory.addTextNode(lastTapPos);
    setState(() {
      state = _eMindMapEditorState.PanAndZoom;
      lastTapPos = null;
    });
  }

  void _selectNode(int index) {
    setState(() {
      // if (selectedNodeIndex != null) {
      //   _deselect();
      // }
      selectedNodeIndex = index;
      state = index == null ? _eMindMapEditorState.PanAndZoom : _eMindMapEditorState.Selecting;
      if (index != null) lastTapPos = null;
    });
  }

  void _deselect() => _selectNode(null);
//endregion
}

enum _eMindMapEditorState {
  PanAndZoom,
  Adding,
  Selecting,
}
