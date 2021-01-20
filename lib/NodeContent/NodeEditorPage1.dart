part of nodes;

class NodeEditorContent extends StatefulWidget {
  @override
  _NodeEditorContentState createState() => _NodeEditorContentState();
}

class _NodeEditorContentState extends State<NodeEditorContent> with TickerProviderStateMixin {
  final List<TextEditingController> noteDescription = [];
  final controller = TextEditingController();
  FocusNode textSecondFocusNode = new FocusNode();
  bool isEditingTitle = false;
  var inputText = "";

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
      appBar: AppBar(
          backgroundColor: Color(0xff1B1B2F),
          title: EditableTitle(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              iconSize: 25,
              onPressed: () {},
            ),
          ]),

      body: Container(
        color: Color(0xff1f4068),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
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
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        noteDescription.removeAt(i);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5,5,5,5),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {});
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
                          contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                  );
                },
              ),
            ),
            ]
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.format_size,
                          color: Colors.black, size: 24),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_size,
                          color: Colors.black, size: 30),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_color_text, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_bold, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_underline_outlined,
                          color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.format_italic, color: Colors.black),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.format_list_bulleted, color: Colors.black),
                    ),
                  ],
                ),
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
    if (TextEditingController.text != "") {
      return IconButton(
          icon: Icon(
            Icons.clear,
          ),
          splashColor: Colors.redAccent,
          onPressed: () {
            setState(() {
              TextEditingController.clear();
              // hidingIcon(TextEditingController);
            });
          });
    } else {
      return null;
    }
  }
}
