part of nodes;

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text("Settings"),
    );

    return Scaffold(
      appBar: appBar,
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Setting $index",
                style: TextStyle(fontSize: 25),
                color: Colors.pink,
              ),
            ),
          );
        },
        itemCount: 3,
      ),
    );
    throw UnimplementedError();
  }
}
