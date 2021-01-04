part of login;

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

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(22, 36, 71, 10),
        body: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(40.0),
              child: Column(children: [
                Image.asset("assets/IdeaspaceLogo.png"),
                SizedBox(height: 50),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle_rounded),
                      labelText: "Username",
                      hintText: "Johnny123",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {},
                      ),
                      labelText: "Password",
                      hintText: "***********",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                ),
                SizedBox(height: 20),
                Transform.scale(
                  scale: 0.8,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(104, 127, 154, 10)),
                      ),
                      child: Text("Login",
                          style: TextStyle(
                            color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("Sign Up",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text("Forgot Password?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[600],
                            decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

              ])),
        ));
  }
}
