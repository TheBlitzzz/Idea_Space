part of login;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Duration _animDuration = Duration(milliseconds: 250);
  static const double _fieldHeight = 60;

  final UserManager manager = UserManager();

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  String get _username => _usernameController.text;

  String get _password => _passwordController.text;

  String get _confirmPassword => _confirmPasswordController.text;

  UserModel thisUser;

  bool hasLoaded = false;
  bool isSignUp = false;
  bool showPassword = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[700], //Color.fromARGB(255, 10, 36, 71),
      body: hasLoaded ? _createMainBody() : _createFutureMainBody(),
    );
  }

  //region UI
  Widget _createFutureMainBody() {
    return FutureBuilder<List<UserModel>>(
      future: manager.load(),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          hasLoaded = true;
          return _createMainBody();
        } else if (snapShot.hasError) {
          debugPrint("File error");
          manager.reset();
          hasLoaded = true;
          return _createMainBody();
        } else {
          return _createLoadingScreen();
        }
      },
    );
  }

  Widget _createLoadingScreen() {
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
            child: Text('Loading...'),
          )
        ],
      ),
    );
  }

  Widget _createMainBody() {
    var defaultSpacing = SizedBox(height: 20);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(40.0),
        child: Column(
          children: [
            _createLogo(),
            defaultSpacing,
            _createField(_usernameController, Icons.account_circle_rounded, "Username", "Johnny123"),
            defaultSpacing,
            _createPasswordField(_passwordController, Icons.lock, "Password", "*****"),
            defaultSpacing,
            AnimatedContainer(
              duration: _animDuration,
              height: isSignUp ? _fieldHeight : 0,
              child: isSignUp
                  ? _createPasswordField(_confirmPasswordController, Icons.lock, "Confirm Password", "*****")
                  : null,
            ),
            AnimatedContainer(
              duration: _animDuration,
              height: isSignUp ? 20 : 0,
            ),
            _createLoginButton(),
            _createSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _createLogo() => Image.asset("assets/Ideaspacelogo.png");

  Widget _createField(TextEditingController controller, IconData prefixIcon, String label, String hint,
      {Widget suffix, bool obscureText = false}) {
    var textField = TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffix: suffix,
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      obscureText: obscureText,
    );
    return Container(height: _fieldHeight, child: textField);
  }

  Widget _createPasswordField(TextEditingController controller, IconData prefixIcon, String label, String hint) {
    final Widget visibilityToggle = IconButton(
      icon: Icon(showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
      onPressed: () => setState(() => showPassword = !showPassword),
    );

    return _createField(controller, prefixIcon, label, hint, suffix: visibilityToggle, obscureText: !showPassword);
  }

  Widget _createLoginButton() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      width: double.infinity,
      height: _fieldHeight * 0.8,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(104, 127, 154, 10)),
        ),
        child: Text(!isSignUp ? "Log in" : "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        onPressed: () => isSignUp ? _signUp() : _login(),
      ),
    );
  }

  Widget _createSignUpButton() {
    return TextButton(
      onPressed: _toggleLoginSignUp,
      child: Text(
        isSignUp ? "Log in" : "Sign Up",
        style: TextStyle(fontSize: 14, color: Colors.blue[600], decoration: TextDecoration.underline),
      ),
    );
  }

  //endregion

  //region Logic
  void _toggleLoginSignUp() {
    setState(() => isSignUp = !isSignUp);
    if (!isSignUp) {
      _confirmPasswordController.text = "";
    }
  }

  void _login() {
    if (_username == "" || _password == "") {
      _showWarning("Username and password fields cannot be empty");
      return;
    }

    thisUser = manager.getUser(_username);
    if (thisUser != null) {
      if (_password == thisUser.password) {
        _navigateToHomepage();
        return;
      } else {
        _showWarning("Invalid Credentials");
        return;
      }
    } else {
      _showWarning("No such user");
    }
  }

  void _signUp() {
    if (_username == "" || _password == "" || _confirmPassword == "") {
      _showWarning("Username, password and confirm password fields cannot be empty");
      return;
    }

    if (_password != _confirmPassword) {
      _showWarning("Password and confirm password fields do not match");
      return;
    }

    // (?=.*[A-Z])         // should contain at least one upper case
    //   (?=.*[a-z])       // should contain at least one lower case
    //   (?=.*?[0-9])      // should contain at least one digit
    //   (?=.*?[!@#\$&*~]) // should contain at least one Special character
    //   .{8,}             // should be 8 characters long

    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(_password)) {
      _showWarning("Password should contain at least:\n "
          "  ·one upper case letter\n"
          "  ·one lower case letter\n"
          "  ·one digit\n"
          "  ·one special character\n"
          "  ·8 characters");
      return;
    }

    bool duplicateUsername = manager.getUser(_username) != null;
    if (duplicateUsername) {
      _showWarning("Username has already been taken");
    } else {
      thisUser = new UserModel(_username, _password);
      manager.addNewUser(thisUser);
      _navigateToHomepage();
    }
  }

  void _navigateToHomepage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage(thisUser)));
    setState(() {
      isSignUp = false;
      _usernameController.text = "";
      _passwordController.text = "";
      _confirmPasswordController.text = "";
    });
  }

  void _showWarning(String warningText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(warningText),
          actions: [FlatButton(child: Text('Ok'), onPressed: Navigator.of(context).pop)],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      },
    );
  }
//endregion
}
