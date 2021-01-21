part of mind_mapping;

// class NodeWidget extends StatelessWidget {
//   final BaseNodeModel node;
//   final MindMapEditorState rootMindMap;
//
//   NodeWidget(this.node, this.rootMindMap);
//
//   @override
//   Widget build(BuildContext context) {
//     Widget text = Align(
//       child: Text(node.title, style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
//       alignment: Alignment.center,
//     );
//     Widget button = Material(
//       child: InkWell(
//         onTap: () => rootMindMap.selectNode(node.id),
//         child: text,
//       ),
//       borderRadius: BorderRadius.all(Radius.circular(4)),
//       color: Colors.grey[700],
//     );
//     return button.setSizeAndOffset(node.position, node.size);
//   }
// }
