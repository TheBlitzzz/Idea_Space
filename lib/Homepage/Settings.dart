part of homepage;

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer();

  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  UserManager get getManager => UserManager.getInstance;

  UserModel get getUser => UserManager.getInstance.thisUser;

  @override
  Widget build(BuildContext context) {
    var accountWidgets = [
      BoxItem(
        widget: InkWell(
          child: Text("Edit Password").align(Alignment.center),
          onTap: () => showReenterPasswordDialog(),
        ),
        height: 40,
        bgColour: Colors.blue,
      ),
      BoxItem(
        widget: InkWell(
          child: Text("Logout").align(Alignment.center),
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false),
        ),
        height: 40,
        bgColour: Colors.orange[700],
      ),
      BoxItem(
        widget: InkWell(
          child: Text("Delete Account").align(Alignment.center),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete Account?"),
                    content: Text("Are you sure you want to delete your account? All data will be erased forever!"),
                    actions: [
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text("Yes, I am sure!"),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                          getManager.deleteUser(getUser.username);
                        },
                      ),
                    ],
                  );
                });
          },
        ),
        height: 40,
        bgColour: Colors.pink[700],
      ),
    ];
    var themeWidgets = [
      BoxItem(
        widget: InkWell(
          child: Text("Edit theme colour").align(Alignment.center),
          onTap: () {
            var colourPicker = new NodeColorPicker(getUser.getColour, setThemeColour);
            colourPicker.showColorPicker(context);
          },
        ),
        height: 40,
        bgColour: getUser.getColour,
      ),
    ];
    var aboutWidgets = [
      BoxItem(
        widget: Text("Idea space is about bringing ideas to life."),
        height: 40,
      ),
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
          ExpandableBox(24, 10, themeWidgets, "Theme colour"),
          ExpandableBox(24, 10, aboutWidgets, "About"),
        ],
      ),
    );
  }

  void showReenterPasswordDialog() {
    String password = "";
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text("Reenter password"),
          content: TextFormField(
            obscuringCharacter: "*",
            obscureText: true,
            onChanged: (value) => password = value,
          ),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Submit"),
              onPressed: () {
                if (password != getManager.thisUser.password) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Invalid Credentials"),
                        actions: [FlatButton(child: Text('Ok'), onPressed: Navigator.of(context).pop)],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    },
                  );
                  return;
                }
                Navigator.of(context).pop();
                showEditPasswordDialog();
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  void showEditPasswordDialog() {
    String newPassword = "";
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text("Enter new password"),
          content: TextFormField(
            obscuringCharacter: "*",
            obscureText: true,
            onChanged: (value) => newPassword = value,
          ),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Submit"),
              onPressed: () {
                Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                RegExp regExp = new RegExp(pattern);
                if (!regExp.hasMatch(newPassword)) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("Password should contain at least:\n "
                            "  ·one upper case letter\n"
                            "  ·one lower case letter\n"
                            "  ·one digit\n"
                            "  ·one special character\n"
                            "  ·8 characters"),
                        actions: [FlatButton(child: Text('Ok'), onPressed: Navigator.of(context).pop)],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    },
                  );
                  return;
                }

                Navigator.of(context).pop();
                getUser.editPassword(newPassword);
                getManager.save();
              },
            )
          ],
        );
      },
      context: context,
    );
  }

  void setThemeColour(Color newColour) {
    setState(() {
      getUser.editThemeColour(newColour);
      getManager.save();
    });
  }
}
