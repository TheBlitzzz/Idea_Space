part of mind_mapping;
//
// /// Temporary replaces a NodeWidget when it is selected for :
// /// * editing the size and position,
// /// * linking or connecting to other nodes,
// /// * entering the selected node (delete available after entering node).
// class SelectedNodeWidget extends StatefulWidget {
//   final BaseNodeModel node;
//   final MindMapEditorState rootMindMap;
//
//   SelectedNodeWidget(this.node, this.rootMindMap);
//
//   @override
//   State<StatefulWidget> createState() {
//     return SelectedNodeState();
//   }
// }
//
// class SelectedNodeState extends State<SelectedNodeWidget> {
//   Offset dragStartPos;
//   Offset nodeStartPos;
//   Size nodeStartSize;
//
//   @override
//   Widget build(BuildContext context) {
//     double thickness = 4;
//     double corner = thickness * 5;
//     Size cornerSize = Size(corner, corner);
//     Size finalSize = widget.node.size + Offset(thickness, thickness);
//     Offset offset = Offset((widget.node.size.width + thickness) / 2, (widget.node.size.height + thickness) / 2);
//     BorderRadiusGeometry borderRadius = BorderRadius.all(Radius.circular(thickness));
//
//     Offset toolsOffset = offset + Offset(widget.node.size.width / 2, widget.node.size.height / 2);
//     Widget toolsPainter = CustomPaint(
//       painter: EditorToolsPainter(2),
//       size: Size(120, 120),
//     ).setPosition(toolsOffset);
//     Widget deleteButton = ElevatedButton(
//       onPressed: () => widget.rootMindMap.deleteNode(widget.node.id),
//       style: ButtonStyle(
//         padding: MaterialStateProperty.all(EdgeInsets.all(5)),
//         backgroundColor: MaterialStateProperty.all(Colors.teal[500]),
//       ),
//       child: Icon(
//         Icons.delete,
//         size: 30,
//         color: Colors.white,
//       ),
//     ).setSizeAndOffset(toolsOffset + Offset(0, 60), Size(40, 40));
//     Widget linkButton = ElevatedButton(
//       onPressed: () => widget.rootMindMap.startLinkingNodes(widget.node.id),
//       style: ButtonStyle(
//         padding: MaterialStateProperty.all(EdgeInsets.all(5)),
//         backgroundColor: MaterialStateProperty.all(Colors.teal[500]),
//       ),
//       child: Icon(
//         Icons.link,
//         size: 30,
//         color: Colors.white,
//       ),
//     ).setSizeAndOffset(toolsOffset + Offset(-50, 40), Size(40, 40));
//     Widget openButton = ElevatedButton(
//       onPressed: () => _openNode(),
//       style: ButtonStyle(
//         padding: MaterialStateProperty.all(EdgeInsets.all(5)),
//         backgroundColor: MaterialStateProperty.all(Colors.teal[500]),
//       ),
//       child: Icon(
//         Icons.zoom_out_map,
//         size: 30,
//         color: Colors.white,
//       ),
//     ).setSizeAndOffset(toolsOffset + Offset(50, 40), Size(40, 40));
//     Widget toolsStack = Stack(
//       children: [toolsPainter, linkButton, deleteButton, openButton],
//     );
//
//     // Select outline.
//     Widget outline = Material(
//       borderRadius: borderRadius,
//       color: Colors.blue[300],
//     ).setSize(finalSize);
//
//     // Original node.
//     Widget originalNode = Material(
//       child: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onPanStart: (DragStartDetails details) => _startTranslation(details.globalPosition),
//         onPanUpdate: (DragUpdateDetails details) => _translate(details.globalPosition),
//         onTapUp: (TapUpDetails details) => _openNode(),
//         child: Align(
//           child: Text(widget.node.title, style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
//           alignment: Alignment.center,
//         ),
//       ),
//       borderRadius: borderRadius,
//       color: Colors.grey[700],
//     ).setSizeAndOffset(offset, widget.node.size);
//
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
//
//       widgets.add(cornerWidget.setSizeAndOffset(Offset(finalSize.width * posX, finalSize.height * posY), cornerSize));
//     }
//
//     Widget stack = Stack(
//       children: [toolsStack, outline, originalNode, Stack(children: widgets).setSize(finalSize)],
//     );
//
//     Widget finalWidget = stack.setSize(finalSize + Offset(80, 80));
//     finalWidget = finalWidget.setPosition(widget.node.position - offset);
//
//     return finalWidget;
//   }
//
//   void refresh() => setState(() {});
//
//   void _setDragStart(Offset anchor) {
//     dragStartPos = anchor;
//     nodeStartSize = widget.node.size;
//     nodeStartPos = widget.node.position;
//   }
//
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
//
//   void _startTranslation(Offset position) {
//     dragStartPos = position;
//     nodeStartPos = widget.node.position;
//   }
//
//   void _translate(Offset currentPos) {
//     setState(() {
//       Offset dragOffset = currentPos - dragStartPos;
//       widget.node.position = nodeStartPos + dragOffset;
//     });
//   }
//
//   void _openNode() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => NodeEditorContent()),
//     );
//   }
// }
