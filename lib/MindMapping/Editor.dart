part of mind_map;

class Editor extends StatefulWidget {
  final MindMapFileModel fileData;
  final MindMapModel data;
  final void Function(String) renameFunc;

  Editor(this.fileData, this.data, this.renameFunc);

  @override
  _EditorState createState() => _EditorState(data);
}

class _EditorState extends State<Editor> {
  static const int _showNodeWidgetsFlag = 1, _showNodeToolsFlag = 2, _showTapMarkerFlag = 4, _showEditorToolsFlag = 8;
  static const double _tapMarkerSize = 30;
  static const Color _editorToolColour = Color(0xFFAAAAAA);

  final TransformationController _viewerController = new TransformationController();
  final TextEditingController _textNodeEditingController = new TextEditingController();

  Offset _lastTapPos;
  double zoomAmt;
  int selectedNodeIndex;
  _NodeFactory factory;

  Offset _dragStartPos;
  Offset _nodeStartPos;

  int state = _showNodeWidgetsFlag;

  _EditorState(MindMapModel data) {
    factory =
        new _NodeFactory(data, _selectNode, nodeTranslationStart, nodeTranslate, (details, node, hor, ver) => null);
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
        title: EditableTitle(_editTitle, widget.fileData.title),
      ),
      body: _createMindMapViewer(),
    );
  }

  //region UI
  Widget _createMindMapViewer() {
    List<Widget> widgetsOnViewer = [];

    //region Nodes and node editor tool
    var nodeWidgets = factory._createNodeWidgets(selectedNodeIndex, _textNodeEditingController);
    if (factory.selectedNode != null) {
      nodeWidgets.add(_createNodeTools());
    }
    widgetsOnViewer.add(Stack(children: nodeWidgets));
    //endregion

    //region Editor tap marker and add tools
    if (_getFlag(_showTapMarkerFlag)) {
      // tap marker
      widgetsOnViewer.add(_createTapMarker());

      if (_getFlag(_showEditorToolsFlag)) {
        widgetsOnViewer.add(_createEditorTools());
      }
    }
    //endregion

    return InteractiveViewer(
      child: GestureDetector(
        child: Container(
          child: Stack(children: widgetsOnViewer),
          color: Colors.grey[850],
          height: 3580,
          width: 2480,
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

  Widget _createNodeTools() {
    var node = factory.selectedNode;
    var position = node.getPosition + Offset(10, node.height);
    var actions = [
      ToolAction(Icons.edit_outlined, () => debugPrint("Add")),
      ToolAction(Icons.link, () => debugPrint("Link")),
      ToolAction(Icons.delete, () => debugPrint("Delete")),
    ];
    return _NodeToolStack(position, actions);
  }

  Widget _createTapMarker() {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: _editorToolColour),
        child: InkWell(onTap: _openAddTools),
        width: _tapMarkerSize,
        height: _tapMarkerSize,
      ),
      top: _lastTapPos.dy - _tapMarkerSize / 2,
      left: _lastTapPos.dx - _tapMarkerSize / 2,
    );
  }

  Widget _createEditorTools() {
    var position = _lastTapPos + Offset(0, _tapMarkerSize / 2);
    var actions = [
      ToolAction(Icons.add, _addNode),
      ToolAction(Icons.text_fields_outlined, _addText),
      ToolAction(Icons.image_outlined, () => debugPrint("Image")),
    ];
    return _NodeToolStack(position, actions);
  }

  //endregion

//region Logic
  //region State
  bool _getFlag(int flag) => (state & flag) == flag;

  void _setFlag(int flag, bool value) => setState(() => value ? state |= flag : state &= ~flag);

  //endregion

  void _editTitle(String newTitle) {
    setState(() {
      widget.renameFunc(newTitle);
    });
  }

  // void _setDragStart(Offset anchor) {
  //   dragStartPos = anchor;
  //   nodeStartSize = widget.node.size;
  //   nodeStartPos = widget.node.position;
  // }

//   void _resize(Offset currentPos, int horizontalDir, int verticalDir) {
//     setState(() {
//       horizontalDir = horizontalDir * 2 - 1;
//       verticalDir = verticalDir * 2 - 1;
//       double dx = (horizontalDir * -dragStartPos.dx) + (horizontalDir * currentPos.dx);
//       double dy = (verticalDir * -dragStartPos.dy) + (verticalDir * currentPos.dy);
//       widget.node.size = Size((nodeStartSize.width + dx).abs(), (nodeStartSize.height + dy).abs());
//       double offsetX = dx / 2 * horizontalDir;
//       double offsetY = dy / 2 * verticalDir;
//       widget.node.position = Offset(nodeStartPos.dx + offsetX, nodeStartPos.dy + offsetY);
//     });
//   }

  //region Select
  void _onViewerTap(TapUpDetails details) {
    setState(() {
      _setFlag(_showTapMarkerFlag, true);
      _lastTapPos = details.localPosition;
      _selectNode(null);
    });
  }

  void _openAddTools() => _setFlag(_showEditorToolsFlag, true);

  void _selectNode(int index) {
    setState(() {
      selectedNodeIndex = index;
      if (index == null) {
        // Deselect or clear select
        _setFlag(_showNodeToolsFlag, false);
        _setFlag(_showEditorToolsFlag, false);
      } else {
        // Stop drawing the tap marker.
        _setFlag(_showNodeToolsFlag, true);
        _setFlag(_showTapMarkerFlag, false);
      }
    });
  }

  //endregion

  //region Add functions
  void _addNode() {
    factory.addPageNode(_lastTapPos);
    setState(() => state = _showNodeWidgetsFlag);
  }

  void _addText() {
    factory.addTextNode(_lastTapPos);
    setState(() => state = _showNodeWidgetsFlag);
  }

  void _addImage() {
    factory.addTextNode(_lastTapPos);
    setState(() => state = _showNodeWidgetsFlag);
  }

  //endregion
  //region Node transformations
  void nodeTranslationStart(DragStartDetails details, BaseNodeModel node) {
    _dragStartPos = details.localPosition;
    _nodeStartPos = Offset(node.dx, node.dy);
  }

  void nodeTranslate(DragUpdateDetails details, BaseNodeModel node) {
    setState(() {
      Offset dragVector = details.localPosition - _dragStartPos;
      node.moveTo(_nodeStartPos + dragVector);
    });
  }
//endregion
//endregion
}

//todo move, resize nodes

//     var horizontalPositions = [0, 1, 0, 1];
//     var verticalPositions = [0, 0, 1, 1];
//
//     List<Widget> widgets = [];
//     for (int i = 0; i < 4; i++) {
//       int posX = horizontalPositions[i];
//       int posY = verticalPositions[i];
//
//       Widget cornerWidget = Material(
//         color: Colors.cyan[200],
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         child: GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onPanStart: (DragStartDetails details) => _setDragStart(details.globalPosition),
//           onPanUpdate: (DragUpdateDetails details) => _resize(details.globalPosition, posX, posY),
//         ),
//       );
