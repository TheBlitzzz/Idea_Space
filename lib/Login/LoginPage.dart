part of login;

class LoginPage extends StatefulWidget {
  final bool isSignUp;

  LoginPage(this.isSignUp);

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text(
        widget.isSignUp ? "Sign Up" : "Login",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blueGrey[800],
    );

    SizedBox spacing = SizedBox(height: 20);

    Image logo = Image.asset(
      'assets/MainLogo.png',
      width: 200,
      height: 200,
    );

    Radius borderRadius = Radius.circular(10);
    OutlineInputBorder textFieldBorder = OutlineInputBorder(borderRadius: BorderRadius.all(borderRadius));

    TextField usernameField = TextField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: textFieldBorder,
        // labelStyle: TextStyle(color: Colors.black),
        // labelText: 'Username',
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: "Username",
      ),
      controller: usernameController,
    );

    TextField passwordField = TextField(
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: textFieldBorder,
        // labelStyle: TextStyle(color: Colors.black),
        // labelText: 'Password',
        hintStyle: TextStyle(color: Colors.grey[500]),
        hintText: "Password",
      ),
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: '*',
    );

    Widget loginButton = Transform.scale(
      scale: 0.8,
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            usernameController.text = "";
            passwordController.text = "";
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomepageWidget()));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(borderRadius))),
          ),
          child: Text("Login", style: TextStyle(fontSize: 25, color: Colors.black)),
        ),
      ),
    );

    var children = widget.isSignUp
        ? [
            logo,
            spacing,
            usernameField,
            spacing,
            passwordField,
            spacing,
            TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: textFieldBorder,
                // labelStyle: TextStyle(color: Colors.black),
                // labelText: 'Password',
                hintStyle: TextStyle(color: Colors.grey[500]),
                hintText: "Confirm Password",
              ),
              obscureText: true,
              obscuringCharacter: '*',
            ),
            spacing,
            Transform.scale(
              scale: 0.8,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    usernameController.text = "";
                    passwordController.text = "";
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomepageWidget()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape:
                        MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(borderRadius))),
                  ),
                  child: Text("Sign Up", style: TextStyle(fontSize: 25, color: Colors.black)),
                ),
              ),
            ),
            SizedBox(height: 20),
          ]
        : [
            logo,
            spacing,
            usernameField,
            spacing,
            passwordField,
            spacing,
            loginButton,
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(true))),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text("Forgot Password?"),
            SizedBox(height: 20),
          ];
    Widget column = Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Center(
        child: column,
      ),
    );
  }

}
