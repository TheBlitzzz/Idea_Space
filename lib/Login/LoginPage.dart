part of login;

class Login extends StatefulWidget {
  final UserManager manager;

  Login(this.manager);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Duration _animDuration = Duration(milliseconds: 250);
  static const double _fieldHeight = 60;

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  String get _username {
    return _usernameController.text.trim();
  }

  String get _password {
    return _passwordController.text.trim();
  }

  String get _confirmPassword {
    return _confirmPasswordController.text.trim();
  }

  List<UserModel> allUsers;

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
    var defaultSpacing = SizedBox(height: 20);
    var mainBody = Center(
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
            _createLoginButton(context),
            _createSignUpButton(),
          ],
        ),
      ),
    );
    var loadingScreen = Center(
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
    var futureMainBody = FutureBuilder<List<UserModel>>(
      future: widget.manager.readFromFile(),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          return mainBody;
        } else {
          return loadingScreen;
        }
      },
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 36, 71),
      body: allUsers == null ? futureMainBody : mainBody,
    );
  }

  //region UI
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

  Widget _createLoginButton(BuildContext context) {
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
        onPressed: () => isSignUp ? _signUp() : _login(context),
      ),
    );
  }

  Widget _createSignUpButton() {
    return TextButton(
      onPressed: () => setState(() => isSignUp = !isSignUp),
      child: Text(
        isSignUp ? "Log in" : "Sign Up",
        style: TextStyle(fontSize: 14, color: Colors.blue[600], decoration: TextDecoration.underline),
      ),
    );
  }

  //endregion

  //region Logic
  void _login(BuildContext context) async {
    if (_username == "" || _password == "") {
      _showWarning("Username and password fields cannot be empty");
      return;
    }

    bool validCredentials = false;
    String correctPassword = widget.manager.getUserPassword(_username);
    if (correctPassword != null) {
      if (_password == correctPassword) {
        validCredentials = true;
      }
    }

    if (validCredentials) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(MindMapManager())));
    } else {
      _showWarning("Invalid Credentials");
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

    // (?=.*[A-Z])       // should contain at least one upper case
    //   (?=.*[a-z])       // should contain at least one lower case
    //   (?=.*?[0-9])          // should contain at least one digit
    //   (?=.*?[!@#\$&*~]).{8,}  // should contain at least one Special character

    Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(_password)) {
      _showWarning(
          "Password should contain at least one upper case and lower case letter each, one digit and a special character.");
      return;
    }

    bool duplicateUsername = widget.manager.getUserPassword(_username) != null;
    if (duplicateUsername) {
      _showWarning("Username has already been taken");
    } else {
      widget.manager.addNewUser(_username, _password);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(MindMapManager())));
    }
  }

  void _showWarning(String warningText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(warningText),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//endregion
}

// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// TextButton(
// child: Text(
// "Sign Up",
// style: TextStyle(
// fontSize: 14,
// color: Colors.blue[600],
// decoration: TextDecoration.underline,
// ),
// ),
// onPressed: () => setState(() => isSignUp = !isSignUp),
// ),
// TextButton(
// child: Text(
// "Forgot Password?",
// style: TextStyle(
// fontSize: 14,
// color: Colors.blue[600],
// decoration: TextDecoration.underline,
// ),
// ),
// ),
// ],
// )
//version 1
// class LoginPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => LoginState();
// }
//
// class LoginState extends State<LoginPage> with TickerProviderStateMixin {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   bool hideConfirmPassword = true;
//   bool hidePassword = true;
//   bool isSignUp = false;
//
//   AnimationController _sizeAnimationController;
//   AnimationController _forgetPasswordController;
//   Animation<double> _sizeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _forgetPasswordController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _sizeAnimationController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _sizeAnimation = CurvedAnimation(
//       parent: _sizeAnimationController,
//       curve: Curves.fastOutSlowIn,
//     );
//   }
//
//   @override
//   void dispose() {
//     _forgetPasswordController.dispose();
//     _sizeAnimationController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget _logo() {
//       return Image.asset(
//         'assets/MainLogo.png',
//         width: 200,
//         height: 200,
//       );
//     }
//
//     SizedBox spacing = SizedBox(height: 20);
//
//     Radius borderRadius = Radius.circular(10);
//     OutlineInputBorder textFieldBorder = OutlineInputBorder(borderRadius: BorderRadius.all(borderRadius));
//
//     InputDecoration inputDecoration(String hintText, IconData prefixIcon, Widget suffixIcon) {
//       return InputDecoration(
//         border: textFieldBorder,
//         hintStyle: TextStyle(color: Colors.grey[500]),
//         hintText: hintText,
//         labelText: hintText,
//         prefixIcon: Icon(prefixIcon),
//         suffixIcon: suffixIcon,
//       );
//     }
//
//     TextField _usernameField() {
//       return TextField(
//         decoration: inputDecoration(
//             "Username",
//             Icons.account_circle_rounded,
//             IconButton(
//               icon: Icon(Icons.clear),
//               onPressed: () => usernameController.text = "",
//             )),
//         controller: usernameController,
//       );
//     }
//
//     Widget toggleVisibilityButton(bool toggleBoolean) {
//       return IconButton(
//         icon: Icon(toggleBoolean ? Icons.visibility_outlined : Icons.visibility_outlined),
//         onPressed: () => setState(() => toggleBoolean = !toggleBoolean),
//       );
//     }
//
//     TextField _passwordField() {
//       return TextField(
//         decoration: inputDecoration("Password", Icons.lock_outline_rounded, toggleVisibilityButton(hidePassword)),
//         controller: passwordController,
//         obscureText: true,
//         obscuringCharacter: hidePassword ? '*' : null,
//       );
//     }
//
//     Widget _confirmPasswordField() {
//       TextField textField = TextField(
//         style: TextStyle(color: Colors.black),
//         decoration: inputDecoration(
//             "Confirm Password", Icons.lock_outline_rounded, toggleVisibilityButton(hideConfirmPassword)),
//         controller: confirmPasswordController,
//         obscureText: true,
//         obscuringCharacter: hideConfirmPassword ? '*' : null,
//       );
//       return SizeTransition(
//         sizeFactor: _sizeAnimation,
//         axisAlignment: -1,
//         child: textField,
//       );
//     }
//
//     Widget _loginButton(String buttonText) {
//       return SizedBox(
//         width: MediaQuery.of(context).size.width * 0.6,
//         height: 40,
//         child: ElevatedButton(
//           onPressed: () {
//             usernameController.text = "";
//             passwordController.text = "";
//             confirmPasswordController.text = "";
//             Navigator.push(context, MaterialPageRoute(builder: (context) => HomepageWidget()));
//           },
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
//             shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(borderRadius))),
//           ),
//           child: Text(buttonText, style: TextStyle(fontWeight: ui.FontWeight.bold)),
//         ),
//       );
//     }
//
//     Widget _switchButton() {
//       return TextButton(
//         onPressed: () => setState(() => isSignUp = !isSignUp),
//         style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
//         child: Text(
//           isSignUp ? "Login" : "Sign Up",
//           style: TextStyle(
//             color: Colors.blue[400],
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       );
//     }
//
//     Widget _forgetPassword() {
//       return SizeTransition(
//         sizeFactor: _forgetPasswordController,
//         axisAlignment: -1,
//         child: Align(
//           alignment: Alignment.center,
//           child: TextButton(
//             style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
//             onPressed: () => setState(() => isSignUp = !isSignUp),
//             child: Text(
//               "Forgot Password?",
//               style: TextStyle(
//                 color: Colors.blue[400],
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (isSignUp) {
//       _sizeAnimationController.forward();
//       _forgetPasswordController.reverse();
//     } else {
//       _sizeAnimationController.reverse();
//       _forgetPasswordController.forward();
//     }
//
//     var children = [
//       _logo(),
//       _usernameField(),
//       spacing,
//       _passwordField(),
//       SizeTransition(
//         sizeFactor: _sizeAnimation,
//         axisAlignment: -1,
//         child: spacing,
//       ),
//       _confirmPasswordField(),
//       spacing,
//       _loginButton(isSignUp ? "Sign Up" : "Login"),
//       _switchButton(),
//       _forgetPassword(),
//     ];
//
//     // Text("Forgot Password?"),
//     // SizedBox(height: 20),
//
//     Widget column = Padding(
//       padding: EdgeInsets.all(30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: children,
//       ),
//     );
//
//     return Scaffold(
//       appBar: null,
//       body: Center(
//         child: column,
//       ),
//     );
//   }
// }
