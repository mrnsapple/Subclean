import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SubClean/Registration.dart';
import 'package:SubClean/HomePage.dart';
import 'package:flutter/services.dart';
import 'api.service.dart';
import 'config.dart';
import 'user.dart' as global;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  bool isObsecure = true;
  bool isloading = false;
  bool userIsValid = false;
  String errorText = "";
  String theme = "dark";

  @override
  void initState() {
    super.initState();
    global.config = new Config();
    global.config.readTheme().then((theme) {
      this.theme = theme;
      setState() {}
    });
  }

  _showsnack() {
    final snackbar = SnackBar(
      content: Text(
        'User not Found',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  login() async {
    isloading = true;
    userIsValid = false;
    setState(() {});
    if (_formKey.currentState.validate()) {
      int statusCode = await Api.postSignIn(email: _email, password: _password);
      if (statusCode == 200) {
        userIsValid = true;
      } else {
        userIsValid = false;
        errorText = "The email or password is incorrect";
      }
      isloading = false;
      setState(() {});
      //
    }
    if (userIsValid)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme == "dark" ? ThemeData.dark() : ThemeData(
        primaryColor: Colors.blue,
        buttonColor: Colors.blue
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                width: MediaQuery.of(context).size.width - 30,
                child: loginScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  loginScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 14),
          child: Center(
            child: Image.asset(
              'images/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              return value.contains('@') ? null : 'Please enter a valid email';
            },
            onChanged: (_input) {
              _email = _input;
              setState(() {});
            },
            controller: emailCont,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
                labelText: 'Email'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              if (value.length == 0) {
                this.isloading = false;
                return "You need to enter a password first";
              }
              return null;
            },
            onChanged: (_input) {
              _password = _input;
              setState(() {});
            },
            obscureText: isObsecure,
            controller: passCont,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  child: Icon(
                      isObsecure ? Icons.visibility : Icons.visibility_off),
                  onTap: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                ),
                hintText: 'Password',
                labelText: 'Password'),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: errorText == ""
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorText,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: MaterialButton(
            color: Colors.blue,
            onPressed: () async {
              errorText = "";
              setState(() {});
              login();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: isloading ? CupertinoActivityIndicator() : Text('Login'),
          ),
        ),
        LoginSeparator(),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: FlatButton(
            onPressed: () {
              errorText = "";
              setState(() {});
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(),
                ),
              );
            },
            child: Text(
              'Create an account',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        LoginSeparator(),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: FlatButton(
            onPressed: () async {
              if (theme == "light") {
                theme = "dark";
              } else {
                theme = "light";
              }
              await global.config.saveTheme(theme);
              setState(() {});
            },
            child: Text(
              'Change theme',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }

  LoginSeparator() {
    return Row(
      children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
        Text("OR"),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Divider(
                color: Colors.black,
                height: 36,
              )),
        ),
      ],
    );
  }
}
