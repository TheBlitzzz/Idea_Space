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
  static const double _tapMarkerSize = 30, _resizeCornerSize = 15;
  static const Color _markerColour = Color(0xFFAAAAAA);

  final TransformationController _viewerController = new TransformationController();
  final TextEditingController _textNodeEditingController = new TextEditingController();

  Offset _lastTapPos;
  double zoomAmt;
  int selectedNodeIndex;
  _NodeFactory factory;

  Offset _dragStartPos;
  Offset _nodeStartPos;
  Size _nodeStartSize;

  int state = _showNodeWidgetsFlag;

  _EditorState(MindMapModel data) {
    factory = new _NodeFactory(data, _selectNode, nodeTranslationStart, nodeTranslate);
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
    var nodeWidgets = factory._createNodeWidgets(selectedNodeIndex);
    if (factory.selectedNode != null) {
      var node = factory.selectedNode;
      nodeWidgets.add(_createNodeTools(node));
      nodeWidgets.add(_createResizeWidgets(node));
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

  Widget _createNodeTools(BaseNodeModel node) {
    var position = node.getPosition + Offset(20, node.height);
    var actions = [
      ToolAction(Icons.edit_outlined, () => editNode(node)),
      ToolAction(Icons.link, () => debugPrint("Link")),
      ToolAction(Icons.delete, () => deleteNode(node)),
    ];
    return _NodeToolStack(position, actions);
  }

  Widget _createTapMarker() {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: _markerColour),
        child: InkWell(onTap: _openAddTools),
      ),
      width: _tapMarkerSize,
      height: _tapMarkerSize,
      top: _lastTapPos.dy - _tapMarkerSize / 2,
      left: _lastTapPos.dx - _tapMarkerSize / 2,
    );
  }

  Widget _createEditorTools() {
    var position = _lastTapPos + Offset(0, _tapMarkerSize / 2);
    var actions = [
      ToolAction(Icons.add, _addPage),
      ToolAction(Icons.text_fields_outlined, _addText),
      ToolAction(Icons.image_outlined, _addImage),
    ];
    return _NodeToolStack(position, actions);
  }

  Widget _createResizeWidgets(BaseNodeModel node) {
    var horizontalPositions = [0, 1, 0, 1];
    var verticalPositions = [0, 0, 1, 1];
    double cornerOffset = _resizeCornerSize - _outlineWidth;

    List<Widget> corners = [];
    for (int i = 0; i < 4; i++) {
      int posX = horizontalPositions[i];
      int posY = verticalPositions[i];

      corners.add(Positioned(
        child: _createResizeCorner(node, posX, posY),
        left: (node.width - _outlineWidth) * posX,
        top: (node.height - _outlineWidth) * posY,
        width: _resizeCornerSize,
        height: _resizeCornerSize,
      ));
    }

    var position = node.getPosition - Offset(cornerOffset / 2, cornerOffset / 2);
    return Positioned(
      child: Stack(children: corners),
      left: position.dx,
      top: position.dy,
      width: node.width + cornerOffset,
      height: node.height + cornerOffset,
    );
  }

  Widget _createResizeCorner(BaseNodeModel node, int horizontalDir, int verticalDir) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _defaultNodeColour,
          border: Border.all(color: _markerColour, width: _outlineWidth),
        ),
      ),
      onPanStart: (details) => _nodeResizeStart(details, node),
      onPanUpdate: (details) => _nodeResize(details, node, horizontalDir, verticalDir),
    );
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

  //region Select
  void _onViewerTap(TapUpDetails details) {
    setState(() {
      _setFlag(_showTapMarkerFlag, true);
      _lastTapPos = details.localPosition;
      _selectNode(null);
    });
  }

  void _openAddTools() => _setFlag(_showEditorToolsFlag, true);

  void _selectNode(BaseNodeModel node) {
    setState(() {
      if (node == null) {
        // Deselect or clear select
        debugPrint("deselect");
        _setFlag(_showNodeToolsFlag, false);
        _setFlag(_showEditorToolsFlag, false);
        selectedNodeIndex = null;
        debugPrint(state.toString());
      } else {
        // Stop drawing the tap marker.
        _setFlag(_showNodeToolsFlag, true);
        _setFlag(_showTapMarkerFlag, false);

        if (selectedNodeIndex == node.id) {
          editNode(node);
        } else {
          selectedNodeIndex = node.id;
        }
      }
    });
    debugPrint(state.toString());
  }

  //endregion

  //region Add functions
  void _addPage() {
    factory.addNode(_lastTapPos, eNodeType.Page);
    setState(() => state = _showNodeWidgetsFlag);
  }

  void _addText() {
    factory.addNode(_lastTapPos, eNodeType.Text);
    setState(() => state = _showNodeWidgetsFlag);
  }

  void _addImage() {
    factory.addNode(_lastTapPos, eNodeType.Image);
    setState(() => state = _showNodeWidgetsFlag);
  }

  //endregion

  //region Node transformations
  void _nodeResizeStart(DragStartDetails details, BaseNodeModel node) {
    _dragStartPos = details.localPosition;
    _nodeStartSize = Size(node.width, node.height);
    _nodeStartPos = Offset(node.dx, node.dy);
  }

  void _nodeResize(DragUpdateDetails details, BaseNodeModel node, int horizontalDir, int verticalDir) {
    Offset position = details.localPosition;
    horizontalDir = horizontalDir * 2 - 1;
    verticalDir = verticalDir * 2 - 1;
    double dx = (horizontalDir * -_dragStartPos.dx) + (horizontalDir * position.dx);
    double dy = (verticalDir * -_dragStartPos.dy) + (verticalDir * position.dy);
    double offsetX = dx / 2 * horizontalDir;
    double offsetY = dy / 2 * verticalDir;

    setState(() {
      node.width = (_nodeStartSize.width + dx).abs();
      node.height = (_nodeStartSize.height + dy).abs();
      node.moveTo(Offset(_nodeStartPos.dx + offsetX, _nodeStartPos.dy + offsetY));
      widget.data.save();
    });
  }

  void nodeTranslationStart(DragStartDetails details, BaseNodeModel node) {
    _dragStartPos = details.localPosition;
    _nodeStartPos = Offset(node.dx, node.dy);
  }

  void nodeTranslate(DragUpdateDetails details, BaseNodeModel node) {
    setState(() {
      Offset dragVector = details.localPosition - _dragStartPos;
      node.moveTo(_nodeStartPos + dragVector);
      widget.data.save();
    });
  }

//endregion

  //region Node Tools
  void editNode(BaseNodeModel node) {
    node.edit(context, onEndEdit: () => setState(() {}));
  }

  void linkNodes() {}

  void deleteNode(BaseNodeModel node) {
    debugPrint("Delete");
    factory.deleteNode(node);
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
