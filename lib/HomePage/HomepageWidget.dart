part of homepage;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _itemSize = 50,
      _appBarOffset = 50,
      // _bottomButtonSpacing = 40,
      // _navigationBarIconSize = 32,
      _borderRadius = 20;
  TextEditingController _searchController = TextEditingController();
  int _currentSelected = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AppBar appBar = AppBar(
    //   title: Align(
    //     alignment: Alignment.centerLeft,
    //     child: Text(
    //       "User's IdeaSpace",
    //       style: TextStyle(color: Colors.white),
    //     ),
    //   ),
    //   leading: Icon(Icons.home),
    // );

    Widget stack = Stack(
      fit: StackFit.expand,
      children: [
        _createDocumentList(),
        _createSearchBar(),
      ],
    );
    return Scaffold(
      // appBar: appBar,
      body: Center(
        child: stack,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 36),
        onPressed: () {},
      ),
      bottomNavigationBar: _createBottomNavigationBar(),
    );
  }

  Widget _createSearchBar() {
    Widget title = Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            iconSize: 24,
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          Text("User's Space", style: TextStyle(fontSize: 20)),
        ],
      ),
    );
    Widget searchField = TextField(
      controller: _searchController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(_borderRadius)),
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: "Search",
        contentPadding: EdgeInsets.all(10),
        prefixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () => debugPrint("Start Search"),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _searchController.text = "",
        ),
      ),
    );
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(height: _appBarOffset),
          title,
          SizedBox(height: 10),
          searchField,
        ],
      ),
    );
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
  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
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
        _selectedIndex = index;
      }),
    );
  }

  Widget _createDocumentList() {
    return Container(
      padding: EdgeInsets.only(top: 140 + _appBarOffset),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 31, 64, 104),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_borderRadius),
            topRight: Radius.circular(_borderRadius),
          ),
        ),
        child: ListView.builder(
          clipBehavior: Clip.hardEdge,
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 10, right: 10),
          itemBuilder: _createDocumentItem,
          itemCount: 20,
          itemExtent: _itemSize + 20,
        ),
      ),
    );
  }

  Widget _createDocumentItem(BuildContext context, int index) {
    Widget button = InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
    );
    Widget lastEdit = Text(
      index == _currentSelected ? "12th December 2020" : "30th February 2019",
      style: TextStyle(fontSize: 10),
      textAlign: TextAlign.center,
    );
    Widget icon = Icon(
      Icons.menu_book,
      size: _itemSize,
    );
    Widget moreButton = IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        debugPrint("More Options");
      },
    );
    Widget title = Text("Hello");
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            button,
            Align(
              alignment: Alignment.centerLeft,
              child: icon,
            ),
            Padding(
              padding: EdgeInsets.only(left: _itemSize + 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: title,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: lastEdit,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: moreButton,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}

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
