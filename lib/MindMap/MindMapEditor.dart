part of mind_mapping;
//
// class MindMapEditorPage extends StatefulWidget {
//   final MindMapFileModel data;
//   final MindMapFileManager manager;
//
//   MindMapEditorPage(this.data, this.manager);
//
//   @override
//   State<StatefulWidget> createState() => MindMapEditorState(data.title);
// }
//
// class MindMapEditorState extends State<MindMapEditorPage> with TickerProviderStateMixin {
//   List<Widget> nodeWidgets = List();
//   List<BaseNodeModel> nodes = List();
//   List<Widget> nodeLinks = List();
//   Offset editorToolsPosition;
//   int lastSelectedNodeIndex;
//   bool isEditingTitle = false;
//   TextEditingController titleController;
//   FloatingActionButton floatingButton;
//
//   String title;
//
//   bool isLinking = false;
//   int linkStartIndex;
//   int linkEndIndex;
//
//   TransformationController viewerTransformation;
//   AnimationController editorToolsController;
//   Animation editorToolsAnim;
//   Widget editorTools;
//
//   MindMapEditorState(this.title);
//
//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController();
//     viewerTransformation = TransformationController();
//
//     editorToolsController = AnimationController(
//       duration: const Duration(milliseconds: 100),
//       vsync: this,
//     );
//
//     editorToolsAnim = CurvedAnimation(
//       parent: editorToolsController,
//       curve: Curves.fastOutSlowIn,
//     );
//
//     double size = 200;
//     double buttonSize = 50;
//     ButtonStyle buttonStyle = ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(5)));
//
//     Widget addButton = ElevatedButton(
//       onPressed: () => setState(() {
//         _createNode(editorToolsPosition);
//         editorToolsPosition = null;
//       }),
//       style: buttonStyle,
//       child: Icon(
//         Icons.add,
//         size: buttonSize / 3 * 2,
//       ),
//     ).setSizeAndOffset(Offset(size / 2, buttonSize / 2), Size(buttonSize, buttonSize));
//     Widget imageButton = ElevatedButton(
//       onPressed: () => setState(() {}),
//       child: Icon(
//         Icons.image_outlined,
//         size: buttonSize / 3 * 2,
//       ),
//       style: buttonStyle,
//     ).setSizeAndOffset(Offset(30, size - buttonSize * 1.05), Size(buttonSize, buttonSize));
//     Widget shapesButton = ElevatedButton(
//       onPressed: () => setState(() {
//         isLinking = true;
//       }),
//       child: Icon(
//         Icons.text_fields,
//         size: buttonSize / 3 * 2,
//       ),
//       style: buttonStyle,
//     ).setSizeAndOffset(Offset(size - 30, size - buttonSize * 1.05), Size(buttonSize, buttonSize));
//
//     Widget editorToolDrawer = CustomPaint(
//       painter: EditorToolsPainter(5),
//       size: Size(150, 150),
//     ).setPosition(Offset(size / 2, size / 2));
//
//     Widget editorToolStack = Stack(
//       children: [editorToolDrawer, addButton],
//     );
//
//     editorTools = ScaleTransition(
//       scale: editorToolsAnim,
//       child: editorToolStack,
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     titleController.dispose();
//     viewerTransformation.dispose();
//     editorToolsController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppBar bar = AppBar(
//       title: isEditingTitle
//           ? TextField(
//               autofocus: true,
//               controller: titleController..text = title,
//               decoration: InputDecoration(border: InputBorder.none, hintText: 'Title'),
//               onSubmitted: (value) {
//                 setState(() {
//                   isEditingTitle = false;
//                   widget.manager.renameMindMap(title, value);
//                   title = value;
//                   debugPrint("submitting");
//                 });
//               },
//             )
//           : GestureDetector(
//               onLongPress: () {
//                 setState(() {
//                   isEditingTitle = true;
//                   debugPrint("changing title");
//                 });
//               },
//               child: Text(
//                 title,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//       // actions: [
//       // IconButton(
//       //   icon: Icon(Icons.undo),
//       //   onPressed: () => debugPrint("UNDOING"),
//       // ),
//       // IconButton(
//       //   icon: Icon(Icons.redo),
//       //   onPressed: () => debugPrint("REDOING"),
//       // ),
//       // IconButton(
//       //   icon: Icon(Icons.more_vert),
//       //   onPressed: () => debugPrint("Going into mind map settings"),
//       // ),
//       // ],
//       backgroundColor: Colors.blueGrey[800],
//     );
//     Widget contextHelper = Align(
//       alignment: Alignment.topCenter,
//       child: Text(
//         "\nEditing Mind Map",
//       ),
//     );
//
//     return Scaffold(
//       appBar: bar,
//       body: Stack(
//         children: [
//           _createViewer(),
//           contextHelper,
//         ],
//       ),
//       // floatingActionButton: floatingButton,
//     );
//   }
//
//   Widget _createViewer() {
//     List<Widget> uiElements = List();
//
//     GestureDetector detector = GestureDetector(
//       onTapUp: (TapUpDetails details) {
//         if (lastSelectedNodeIndex != null) {
//           deselectActiveSelection();
//         } else if (isLinking) {
//           setState(() => isLinking = false);
//         } else {
//           setState(() => editorToolsPosition = editorToolsPosition != null ? null : details.localPosition);
//         }
//       },
//     );
//
//     uiElements.add(detector);
//     uiElements.addAll(nodeLinks);
//     uiElements.addAll(nodeWidgets);
//
//     if (editorToolsPosition != null && isLinking == false) {
//       editorToolsController.forward(from: 0);
//       uiElements.add(editorTools.setSizeAndOffset(editorToolsPosition, Size(200, 200)));
//     }
//
//     BoxDecoration boxDecoration = BoxDecoration(
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//       gradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: <Color>[Colors.grey[800], Colors.grey[900], Colors.grey[800]],
//         stops: <double>[0.0, 0.5, 1.0],
//       ),
//       border: Border.all(
//         color: Colors.grey[400],
//         width: 5,
//       ),
//     );
//
//     InteractiveViewer interactiveViewer = InteractiveViewer(
//       minScale: 0.05,
//       maxScale: 4,
//       constrained: false,
//       boundaryMargin: EdgeInsets.all(50),
//       transformationController: viewerTransformation,
//       child: Stack(children: uiElements).setDecoration(Size(1000, 1000), boxDecoration),
//     );
//
//     return interactiveViewer;
//   }
//
//   //region Logic
//   void _createNode(Offset position) {
//     int index = nodeWidgets.length;
//     setState(() {
//       // nodes.add(TextNodeModel(index, Size(120, 80), position, false));
//       NodeWidget nodeWidget = NodeWidget(
//         nodes[index],
//         this,
//       );
//       nodeWidgets.add(nodeWidget);
//     });
//   }
//
//   void deleteNode(int index) {
//     deselectActiveSelection();
//     setState(() {
//       nodeWidgets.removeAt(index);
//       nodes.removeAt(index);
//       for (int i = 0; i < nodeWidgets.length; i++) {
//         nodes[i].id = i;
//       }
//     });
//   }
//
//   void selectNode(int index) {
//     setState(() {
//       editorToolsPosition = null;
//       if (isLinking) {
//         if (linkStartIndex == null) {
//           linkStartIndex = index;
//         } else {
//           linkEndIndex = index;
//           isLinking = false;
//           nodeLinks.add(NodeLink(NodeLinkInfo(nodes[linkStartIndex], nodes[linkEndIndex])));
//           linkStartIndex = linkEndIndex = null;
//         }
//       } else {
//         _setLastSelected(false);
//         lastSelectedNodeIndex = index;
//         _setLastSelected(true);
//         floatingButton = null;
//       }
//     });
//   }
//
//   void startLinkingNodes(int from) {
//     setState(() {
//       isLinking = true;
//       linkStartIndex = from;
//     });
//   }
//
//   void deselectActiveSelection() {
//     setState(() {
//       editorToolsPosition = null;
//       _setLastSelected(false);
//       lastSelectedNodeIndex = null;
//       floatingButton = null;
//       floatingButton = FloatingActionButton(
//         onPressed: () => debugPrint("Not implemented : Recenter mind map"),
//         child: Icon(
//           Icons.location_searching,
//           size: 40,
//         ),
//       );
//     });
//   }
//
//   void _setLastSelected(bool value) {
//     if (lastSelectedNodeIndex != null) {
//       // nodes[lastSelectedNodeIndex].isSelected = value;
//       nodeWidgets.removeAt(lastSelectedNodeIndex);
//       Widget widget = value
//           ? SelectedNodeWidget(nodes[lastSelectedNodeIndex], this)
//           : NodeWidget(nodes[lastSelectedNodeIndex], this);
//       nodeWidgets.insert(lastSelectedNodeIndex, widget);
//     }
//   }
// //endregion
// }
