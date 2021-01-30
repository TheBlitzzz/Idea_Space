part of homepage;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  final MindMapFileManager manager = new MindMapFileManager();

  int _selectedIndex = 0;
  List<MindMapFileModel> searchDomain;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = UserManager.getInstance.thisUser;
    manager.setUser(user.username);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(title: Text("${user.username}'s Space")),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            searchDomain != null ? _createDocumentList() : _createFutureDocumentList(),
            _createSearchBar(),
          ],
        ),
      ),
      endDrawer: SettingsDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.grey[200],
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
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FlatButton(
          child: Text('Create'),
          onPressed: () {
            _createNewMindMap(mindMapName);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _createSearchBar() {
    return Column(children: [
      SizedBox(height: 10),
      SearchField(_searchController, _searchFile),
    ]).pad(10, 10, 10, 10);
  }

  Widget _createFutureDocumentList() {
    return FutureBuilder<List<MindMapFileModel>>(
      future: manager.load(),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          searchDomain = snapShot.data;
          return _createDocumentList();
        } else if (snapShot.hasError) {
          debugPrint("File error");
          manager.reset();
          _searchFile();
          return _createLoadProgressIndicator();
        } else {
          return _createLoadProgressIndicator();
        }
      },
    );
  }

  Widget _createLoadProgressIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator().setSize(Size(60, 60)),
          Text('Loading data...').pad(0, 0, 16, 0),
        ],
      ),
    );
  }

  Widget _createDocumentList() {
    return Container(
      padding: EdgeInsets.only(top: 80, left: 10, right: 10),
      child: Container(
          decoration: BoxDecoration(
            color: UserManager.getInstance.thisUser.getColour,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_borderRadius),
              topRight: Radius.circular(_borderRadius),
            ),
          ),
          child: searchDomain == null || searchDomain.isEmpty
              ? Text(
                  "Create a new file to start mind mapping!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  itemBuilder: _createDocumentItem,
                  itemCount: searchDomain.length,
                  itemExtent: _documentItemSize + 20,
                )),
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
    children.add(InkWell(onTap: () => _openMindMap(data)));

    var row = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.bookmark, color: data.isBookMarked ? Colors.amber : Colors.white),
          onPressed: () => _toggleBookmark(index),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteMindMap(data.title),
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
      ],
      iconSize: 32,
      backgroundColor: Color.fromARGB(255, 27, 27, 47),
      showUnselectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[600],
      onTap: (index) => setState(() {
        _selectedIndex = index;
        _searchFile();
      }),
    );
  }

  //endregion

  //region Logic
  void _searchFile({String searchTerm}) {
    if (searchTerm == null) searchTerm = _searchController.text;
    setState(() {
      searchDomain = manager.searchFile(searchTerm, MindMapType.values[_selectedIndex]);
    });
  }

  void _createNewMindMap(String mindMapName) {
    var newMindMap = MindMapFileModel(mindMapName, UserManager.getInstance.thisUser.username, DateTime.now());
    setState(() => manager.addNewMindMap(newMindMap));
    _searchFile();
  }

  void _toggleBookmark(int index) {
    setState(() => manager.toggleBookmark(index));
    _searchFile();
  }

  void _deleteMindMap(String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Mind Map?"),
            content: Text("Are you sure you want to delete '$title'?"),
            actions: [
              FlatButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Yes, I am sure!"),
                onPressed: () {
                  setState(() => manager.deleteMindMap(title));
                  _searchFile();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _renameMindMap(MindMapModel mindMap, String newTitle) {
    manager.renameMindMap(mindMap, newTitle);
    _searchFile();
  }

  void _openMindMap(MindMapFileModel fileData) async {
    var mindMap = await manager.getMindMap(fileData.title);
    var renameFunc = (newTitle) => _renameMindMap(mindMap, newTitle);

    Navigator.push(context, MaterialPageRoute(builder: (context) => MindMap.Editor(fileData, mindMap, renameFunc)));
  }
  //endregion
}
