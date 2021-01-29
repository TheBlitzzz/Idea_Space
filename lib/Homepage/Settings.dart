part of homepage;

class SettingsDrawer extends StatefulWidget {
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
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
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false),
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
}
