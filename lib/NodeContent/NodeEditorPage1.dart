part of nodes;

class NodeEditorContent extends StatefulWidget {
  @override
  _NodeEditorContentState createState() => _NodeEditorContentState();
}

class _NodeEditorContentState extends State<NodeEditorContent> with TickerProviderStateMixin {
  final List<TextEditingController> noteDescription = [];
  final controller = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  AnimationController _controller;
  var inputText = "";

  double width = 0;
  double height = 60;

  double _openMenu() {
    setState(() {
      width = 150;
    });
  }

  double _closeMenu() {
    setState(() {
      width = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < noteDescription.length; i++) {
      noteDescription[i].dispose();
    }
  }

  List<Widget> textBlock = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff1B1B2F),
          title: Text("Node-1"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              iconSize: 25,
              onPressed: () {},
            ),
          ]),
      // bottomNavigationBar: BottomAppBar(
      //     shape: AutomaticNotchedShape(
      //       RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(20),
      //           topRight: Radius.circular(20),
      //         ),
      //       ),
      //     ),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.undo),
      //           iconSize: 40,
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.add_circle_outline_rounded),
      //           iconSize: 50,
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.redo),
      //           iconSize: 40,
      //         ),
      //       ],
      //     )
      // ),
      body: Container(
        color: Color(0xff1f4068),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                maxLines: 1,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(20),
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  // border: OutlineInputBorder(
                  //   borderRadius: const BorderRadius.all(
                  //     const Radius.circular(10.0),
                  //   ),
                  // ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                itemCount: noteDescription.length,
                itemBuilder: (context, int i) {
                  final f = noteDescription[i];
                  final inputController = f;
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: ValueKey(noteDescription[i]),
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        child: Icon(Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        noteDescription.removeAt(i);
                      });
                    },
                    child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {
                                });
                              },
                              maxLines: null,
                              controller: inputController,
                              decoration: InputDecoration(
                                filled: true,
                                suffixIcon: hidingIcon(inputController),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.fromLTRB(
                                    20, 20, 20, 20),
                                hintText: "Write your description here",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                // border: OutlineInputBorder(
                                //   borderRadius: const BorderRadius.all(
                                //     const Radius.circular(10.0),
                                //   ),
                                // ),
                              ),
                            ),
                          ),
                          // AnimatedContainer(
                          //   duration: Duration(milliseconds: 300),
                          //   width: width,
                          //   height: height,
                          //   decoration: BoxDecoration(
                          //     color: Color(0xFFFFFFF),
                          //     borderRadius: BorderRadius.circular(10.0),
                          //   ),
                          //   child: Row(
                          //       children: <Widget>[
                          //         IconButton(
                          //           icon: Icon(
                          //             Icons.arrow_drop_up_outlined,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //         IconButton(
                          //           icon: Icon(
                          //             Icons.arrow_drop_down_outlined,
                          //             color: Colors.black,
                          //           ),
                          //         ),
                          //         IconButton(
                          //           icon: Icon(
                          //             Icons.delete,
                          //             color: Colors.red,
                          //            ),
                          //         ),
                          //       ]
                          //   ),
                          // ),
                        ]
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Column(
      //     children: [
      //       TextField(
      //         decoration: InputDecoration(
      //           hintText: "Title",
      //           hintStyle: TextStyle(
      //             fontSize: 30,
      //           ),
      //           contentPadding: EdgeInsets.fromLTRB(30, 30, 30, 20),
      //         ),
      //       ),
      //       SizedBox(height: 30),
      //     ],
      //   ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            noteDescription.add(TextEditingController());
            textBlock.add(
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                key: ValueKey('${noteDescription.length}'),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.menu,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: TextField(
                        controller: noteDescription[noteDescription.length - 1],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
  Widget hidingIcon(TextEditingController) {
    if (TextEditingController.text!="") {
      return IconButton(
          icon: Icon(
            Icons.clear,
          ),
          splashColor: Colors.redAccent,
          onPressed: () {
              setState((){
                TextEditingController.clear();
                // hidingIcon(TextEditingController);
              });
          });
    } else {
      return null;
    }
  }
}

