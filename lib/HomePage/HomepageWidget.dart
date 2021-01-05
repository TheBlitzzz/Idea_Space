part of homepage;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double itemSize = 250;
  final Radius borderRadius = Radius.circular(10);
  TextEditingController _searchController = TextEditingController();
  int currentSelected = 0;

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
    AppBar appBar = AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "User's IdeaSpace",
          style: TextStyle(color: Colors.white),
        ),
      ),
      leading: Icon(Icons.home),
    );

    Widget stack = Stack(
      fit: StackFit.expand,
      children: [
        _createDocumentList(),
        _createBottomButtons(),
        _createSearchBar(),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: stack,
      ),
    );
  }

  Widget _createSearchBar() {
    Widget title = Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.menu),
          SizedBox(width: 20),
          Text(
            "User's Space",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
    Widget searchField = TextField(
      controller: _searchController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(borderRadius)),
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
          title,
          SizedBox(height: 10),
          searchField,
        ],
      ),
    );
  }

  Widget _createDocumentList() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 125, right: 125, top: 250, bottom: 250),
      itemBuilder: _createDocumentItem,
      itemCount: 10,
    );
  }

  Widget _createDocumentItem(BuildContext context, int index) {
    Widget button = InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
      child: Text("Hello"),
    );
    // Widget title = Align(
    //   // alignment: Alignment.topCenter,
    //   child: Text(
    //     index == currentSelected ? "School Related Ideas" : "Doodles",
    //     style: TextStyle(fontSize: 20),
    //     textAlign: TextAlign.center,
    //   ),
    // );
    Widget lastEdit = Align(
      child: Text(
        index == currentSelected ? "12th December 2020" : "30th February 2019",
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
      ),
    );
    Widget icon = Icon(Icons.menu_book);
    Widget title = Text("Henlos");
    return Column(
      children: [
        button,
        title,
        lastEdit,
      ],
    );
  }

  Widget _createBottomButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 48,
              icon: Icon(Icons.logout),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              iconSize: 48,
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MindMapEditorPage())),
            ),
            IconButton(
              iconSize: 48,
              icon: Icon(Icons.settings),
              onPressed: () => debugPrint("Configuring settings"),
            ),
          ],
        ),
      ),
    );
  }
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
