part of homepage;

class HomePage extends StatefulWidget {
  final MindMapManager manager;

  HomePage(this.manager);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  List<MindMapModel> searchDomain;
  static const _animDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      fit: StackFit.expand,
      children: [
        _createCenterList(),
        _createSearchBar(),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: new AppBar(
        title: Text("User's Space"),
        leading: Icon(Icons.account_circle_rounded),
      ),
      body: Center(
        child: stack,
      ),
      endDrawer: _createSettingsDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 36),
        onPressed: () => showDialog(context: context, builder: (_) => _createAddMindMapDialog()),
      ),
      bottomNavigationBar: _createBottomNavigationBar(),
    );
  }

  //region UI
  Widget _createAddMindMapDialog() {
    String mindMapName = "Untitled";
    return AlertDialog(
      title: new Text("Creating a new Mind Map"),
      content: new TextField(
        onChanged: (name) => mindMapName = name,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Create mind map!'),
          onPressed: () {
            _createNewMindMap(mindMapName);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Never mind'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Widget _createSettingsDrawer(BuildContext context) {
    var aboutWidgets = [
      BoxItem(
        widget: Text("Idea space is about bringing ideas to life."),
        height: 40,
      )
    ];
    var accountWidgets = [
      BoxItem(
        widget: InkWell(
          child: Text("Logout").align(Alignment.center),
          onTap: () async {
            Navigator.of(context).pop();
            await Future.delayed(_animDuration);
            Navigator.of(context).pop();
          },
        ),
        height: 40,
        bgColour: Colors.pink[500],
      )
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Settings', style: TextStyle(fontSize: 40)),
            duration: _animDuration,
            decoration: BoxDecoration(color: Colors.blue),
          ).wrapSized(height: 150),
          ExpandableBox(24, 10, accountWidgets, "Account"),
          // ExpandableBox(24, 10, [], "Theme colour"),
          // ExpandableBox(24, 10, [], "Notification settings"),
          ExpandableBox(24, 10, aboutWidgets, "About"),
        ],
      ),
    );
  }

  Widget _createSearchBar() {
    return Column(
      children: [
        SizedBox(height: 10),
        SearchField(_searchController, _searchFile),
      ],
    ).pad(10, 10, 10, 10);
  }

  Widget _createCenterList() {
    return FutureBuilder<List<MindMapModel>>(
      future: widget.manager.readFromFile(),
      builder: (context, snapShot) {
        if (searchDomain != null) {
          return _createDocumentList();
        }

        if (snapShot.hasData) {
          searchDomain = snapShot.data;
          return _createDocumentList();
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget _createDocumentList() {
    return Container(
      padding: EdgeInsets.only(top: 80, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 31, 64, 104),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_borderRadius),
            topRight: Radius.circular(_borderRadius),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10, right: 10),
          itemBuilder: _createDocumentItem,
          itemCount: searchDomain.length,
          itemExtent: _documentItemSize + 20,
        ),
      ),
    );
  }

  Widget _createDocumentItem(BuildContext context, int index) {
    var data = searchDomain[index];
    var children = new List<Widget>();

    // File Icon
    children.add(Icon(
      Icons.menu_book,
      size: _documentItemSize * 0.8,
    ).align(Alignment.centerLeft));

    // Title and last edit
    children.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data.title, style: TextStyle(fontSize: 20)).align(Alignment.centerLeft),
        SizedBox(height: 5),
        Text(data.getLastEditTime, style: TextStyle(fontSize: 11)).align(Alignment.centerLeft),
      ],
    ).pad(_documentItemSize, 0, 0, 0));

    // bottom divider
    children.add(Container(height: 2, color: Colors.white).align(Alignment.bottomCenter));
    // button to open the file
    children.add(InkWell(onTap: () => _openMindMap()));

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.bookmark, color: data.isBookMarked ? Colors.amber : Colors.white),
          onPressed: () => _toggleBookmark(index),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteMindMap(index),
        ),
      ],
    );
    children.add(row);

    return Stack(
      fit: StackFit.expand,
      children: children,
    ).pad(10, 10, 5, 5);
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: "All",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "Recent",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: "Bookmarked",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: "Shared",
        ),
      ],
      iconSize: 32,
      backgroundColor: Color.fromARGB(255, 27, 27, 47),
      showUnselectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
      onTap: (index) => setState(() {
        if (index == 3) return;
        _selectedIndex = index;
        searchDomain = widget.manager.getFiles(MindMapType.values[_selectedIndex]);
      }),
    );
  }

  //endregion

  //region Logic
  void _searchFile({String searchTerm}) {
    setState(() {
      searchDomain = widget.manager.getFiles(MindMapType.values[_selectedIndex]);
    });
    if (searchTerm == null) {
      searchTerm = _searchController.text;
      return;
    }
    debugPrint("Searching");
    List<MindMapModel> tempDomain = [];
    for (int i = 0; i < searchDomain.length; i++) {
      if (searchDomain[i].title.contains(searchTerm)) {
        tempDomain.add(searchDomain[i]);
      }
    }

    // TODO make the list display 'no files found' text or something
    if (tempDomain.isEmpty) {
      debugPrint("Nothing found");
    }

    tempDomain.sort((a, b) => (a.title.toUpperCase()).compareTo(b.title.toUpperCase()));
    searchDomain = tempDomain;
  }

  void _createNewMindMap(String mindMapName) {
    setState(() => widget.manager.addNewMindMap(MindMapModel(mindMapName, DateTime.now())));
    _searchFile();
  }

  void _toggleBookmark(int index) {
    setState(() => widget.manager.toggleBookmark(index));
    _searchFile();
  }

  void _deleteMindMap(int index) {
    setState(() => widget.manager.deleteMindMapAt(index));
    _searchFile();
  }

  //todo add title parameter
  void _openMindMap() => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage()));
//endregion
}

// Widget _createDocumentTab() {
//   double tabWidth = MediaQuery.of(context).size.width / 4;
//   return Padding(
//     padding: EdgeInsets.only(top: 100 + _appBarOffset),
//     child: Container(
//       padding: EdgeInsets.only(top: 5),
//       height: 60,
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 27, 27, 47),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(_borderRadius),
//           topRight: Radius.circular(_borderRadius),
//         ),
//       ),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: tabWidth,
//               child: TextButton(
//                 child: Text("Recent"),
//               ),
//             ),
//             SizedBox(
//               width: tabWidth,
//               child: TextButton(
//                 child: Text("All"),
//               ),
//             ),
//             SizedBox(
//               width: tabWidth,
//               child: TextButton(
//                 child: Text("Favourites"),
//               ),
//             ),
//             SizedBox(
//               width: tabWidth,
//               child: TextButton(
//                 child: Text("Shared"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// Widget _createBottomButtons() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       IconButton(
//         iconSize: _navigationBarIconSize,
//         icon: Icon(Icons.logout),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//       SizedBox(width: _bottomButtonSpacing),
//       IconButton(
//         iconSize: _navigationBarIconSize,
//         icon: Icon(Icons.add),
//         onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
//       ),
//       SizedBox(width: _bottomButtonSpacing),
//       IconButton(
//         iconSize: _navigationBarIconSize,
//         icon: Icon(Icons.settings),
//         onPressed: () => debugPrint("Configuring settings"),
//       ),
//     ],
//   );
// }

// class HomepageWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => HomepageState();
// }
//
// class HomepageState extends State<HomepageWidget> {
//   static const double itemSize = 250;
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   int currentSelected = 0;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AppBar appBar = AppBar(
//       title: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           "User's IdeaSpace",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       leading: Icon(Icons.home),
//     );
//
//     Radius borderRadius = Radius.circular(10);
//
//     Widget searchBar = Padding(
//       padding: EdgeInsets.all(10),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               "All Files",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//           Container(height: 10),
//           TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(borderRadius: BorderRadius.all(borderRadius)),
//               hintStyle: TextStyle(color: Colors.grey[500]),
//               hintText: "Search",
//               contentPadding: EdgeInsets.all(10),
//               prefixIcon: IconButton(
//                 icon: Icon(Icons.search),
//                 onPressed: () => debugPrint("Start Search"),
//               ),
//               suffixIcon: IconButton(
//                 icon: Icon(Icons.clear),
//                 onPressed: () => _searchController.text = "",
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//     Widget documentList = NotificationListener<ScrollNotification>(
//       child: ListView.builder(
//         padding: EdgeInsets.only(left: 125, right: 125, top: 250, bottom: 250),
//         scrollDirection: Axis.horizontal,
//         controller: _scrollController,
//         itemBuilder: (context, index) {
//           Widget button = InkWell(
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
//             child: Image.asset(
//               index == currentSelected ? 'assets/LitLightBulb.png' : 'assets/UnlitLightBulb.png',
//             ),
//           );
//           Widget title = Align(
//             // alignment: Alignment.topCenter,
//             child: Text(
//               index == currentSelected ? "School Related Ideas" : "Doodles",
//               style: TextStyle(fontSize: 20),
//               textAlign: TextAlign.center,
//             ),
//           );
//           Widget lastEdit = Align(
//             child: Text(
//               index == currentSelected ? "12th December 2020" : "30th February 2019",
//               style: TextStyle(fontSize: 10),
//               textAlign: TextAlign.center,
//             ),
//           );
//           return Column(
//             children: [
//               button,
//               title,
//               lastEdit,
//             ],
//           );
//         },
//         itemCount: 10,
//         itemExtent: itemSize,
//       ),
//       onNotification: (notification) {
//         if (notification is ScrollStartNotification) {
//         } else if (notification is ScrollUpdateNotification) {
//           setState(() {
//             currentSelected = _scrollController.offset ~/ itemSize;
//           });
//         } else if (notification is ScrollEndNotification) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _scrollController.animateTo(
//               (currentSelected) * itemSize,
//               curve: Curves.easeIn,
//               duration: Duration(milliseconds: 250),
//             );
//           });
//         }
//         return false;
//       },
//     );
//
//     Widget buttons = Align(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 30),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               iconSize: 48,
//               icon: Icon(Icons.logout),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             IconButton(
//               iconSize: 48,
//               icon: Icon(Icons.add),
//               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
//             ),
//             IconButton(
//               iconSize: 48,
//               icon: Icon(Icons.settings),
//               onPressed: () => debugPrint("Configuring settings"),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     Widget stack = Stack(
//       fit: StackFit.expand,
//       children: [
//         documentList,
//         buttons,
//         searchBar,
//       ],
//     );
//
//     return Scaffold(
//       appBar: appBar,
//       body: Center(
//         child: stack,
//       ),
//     );
//   }
// }
