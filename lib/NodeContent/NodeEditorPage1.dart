part of nodes;

class NodeEditorContent extends StatefulWidget {
  @override
  _NodeEditorContentState createState() => _NodeEditorContentState();
}

class _NodeEditorContentState extends State<NodeEditorContent> {
  final TextEditingController nodeTitleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Node-1"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                iconSize: 25,
                onPressed: (){
                },
              ),
            ]
        ),
        bottomNavigationBar: BottomAppBar(
            shape: AutomaticNotchedShape(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.undo),
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline_rounded),
                  iconSize: 50,
                ),
                IconButton(
                  icon: Icon(Icons.redo),
                  iconSize: 40,
                ),
              ],
            )
        ),
        body: Column(

        )
    );
  }
}