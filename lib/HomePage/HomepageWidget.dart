part of homepage;

class HomePage extends StatefulWidget {
  final FileIndexer files;

  HomePage(this.files);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _itemSize = 60, _borderRadius = 20;
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
  List<MindMapModel> searchDomain;

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
      appBar: new AppBar(
        title: Text("User's Space"),
      ),
      body: Center(
        child: stack,
      ),
      drawer: _createSettingsDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 36),
        onPressed: () => showDialog(context: context, builder: (_) => _createAddMindMapDialog()),
      ),
      bottomNavigationBar: _createBottomNavigationBar(),
    );
  }

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
            setState(() => widget.files.addNewFile(MindMapModel("$mindMapName.map", mindMapName, DateTime.now())));
            _searchFile();
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

  Widget _createSettingsDrawer() {
    var aboutWidgets = [
      Text(
        "Hello",
        textAlign: TextAlign.left,
      ),
      Text("Hello"),
      Text("Hello"),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Settings', style: TextStyle(fontSize: 40)),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(color: Colors.blue),
          ).wrapSized(height: 150),
          ExpandableBoxWidget(24, [], "Account"),
          ExpandableBoxWidget(24, [], "Theme colour"),
          ExpandableBoxWidget(24, [], "Notification settings"),
          ExpandableBoxWidget(24, aboutWidgets, "About"),
        ],
      ),
    );
  }

  Widget _createSearchBar() {
    // Widget titleRow = Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     IconButton(
    //       iconSize: 24,
    //       icon: Icon(Icons.menu),
    //       onPressed: () {},
    //     ),
    //     Text("User's Space", style: TextStyle(fontSize: 20)),
    //   ],
    // )..align(Alignment.centerLeft);
    Widget searchField = TextField(
      controller: _searchController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: "Search",
        contentPadding: EdgeInsets.all(10),
        prefixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => _searchFile(),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchController.text = "";
            _searchFile();
          },
        ),
      ),
      onChanged: (searchTerm) => _searchFile(searchTerm: searchTerm),
    );
    return Column(
      children: [
        // SizedBox(height: _appBarOffset),
        // titleRow,
        SizedBox(height: 10),
        searchField,
      ],
    ).pad(10, 10, 10, 10);
  }

  Widget _createCenterList() {
    Widget builder = FutureBuilder<FileIndexModel>(
      future: widget.files.readFileIndex,
      builder: (context, snapShot) {
        if (searchDomain != null) {
          return _createDocumentList();
        }
        if (snapShot.hasData) {
          searchDomain = snapShot.data.allFiles;
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
    return builder;
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
          // clipBehavior: Clip.hardEdge,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10, right: 10),
          itemBuilder: _createDocumentItem,
          itemCount: searchDomain.length,
          itemExtent: _itemSize + 20,
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
      size: _itemSize * 0.8,
    ).align(Alignment.centerLeft));

    // Title and last edit
    children.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data.title, style: TextStyle(fontSize: 20)).align(Alignment.centerLeft),
        SizedBox(height: 5),
        Text(data.getLastEditTime, style: TextStyle(fontSize: 11)).align(Alignment.centerLeft),
      ],
    ).pad(_itemSize, 0, 0, 0));

    // bottom divider
    children.add(Container(
      height: 2,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    ).align(Alignment.bottomCenter));

    // button to open the file
    children.add(InkWell(
      onTap: () => _openMindMap(),
    ));

    // more button
    children.add(IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        debugPrint("More Options");
      },
    ).align(Alignment.centerRight));

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
          label: "Favourites",
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
        searchDomain = widget.files.getFiles(FileListType.values[_selectedIndex]);
      }),
    );
  }

  void _searchFile({String searchTerm}) {
    setState(() {
      searchDomain = widget.files.getFiles(FileListType.values[_selectedIndex]);
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

    tempDomain.sort((a, b) => a.title.compareTo(b.title));
    searchDomain = tempDomain;
  }

  //todo add title parameter
  void _openMindMap() => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage()));
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
