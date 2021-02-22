import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:SubClean/Login.dart';
import 'package:SubClean/api.service.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController firstnameCont = TextEditingController();
  TextEditingController lastnameCont = TextEditingController();
  TextEditingController confPassCont = TextEditingController();
  bool isObsecure = true;
  File _image;
  bool isloading = false;
  bool userValid = false;

  String _email;
  String _check_password;
  String _password;
  String _first_name;
  String _last_name;

  void _showsnack(String val) {
    final snackbar = SnackBar(
      content: Text(
        val,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void register() async {
    setState(() {
      isloading = true;
      userValid = false;
    });
    if (_formKey.currentState.validate()) {
      int statusCode = await Api.postRegister(
          firstname: _first_name,
          lastname: _last_name,
          email: _email,
          password: _password);
      if (statusCode == 201)
        setState(() {
          userValid = true;
        });
      else if (statusCode == 422) {
        return _showsnack('User with Email Already exists');
      } else
        userValid = false;
      isloading = false;
      setState(() {});
      if (userValid)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(18.0),
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  regScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  regScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 70.0, top: 23.0),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Register your account ',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 34.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14.0),
            child: GestureDetector(
              onTap: () {
                final action = CupertinoActionSheet(
                  title: Text('Photo'),
                  message: Text('Choose a Profile Photo'),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      onPressed: () => print('cam'),
                      child: Text('Camera'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => print('gal'),
                      child: Text('Gallery'),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                );
                showCupertinoModalPopup(
                    context: context, builder: (context) => action);
              },
              child: CircleAvatar(
                radius: 34.0,
                backgroundColor: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onChanged: (_input) {
                setState(() {
                  _first_name = _input.toString();
                });
              },
              validator: (_input) {
                return _input.length != 0 ? null : 'Please Enter a Name';
              },
              controller: firstnameCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.near_me),
                  hintText: 'Name',
                  labelText: 'First Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              onChanged: (_input) {
                setState(() {
                  _last_name = _input;
                });
              },
              validator: (_input) {
                return _input.length != 0 ? null : 'Please Enter a Name';
              },
              controller: lastnameCont,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  prefixIcon: Icon(Icons.near_me),
                  hintText: 'Name',
                  labelText: 'Last Name'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              validator: (_input) {
                return _input.contains('@') && _input.length > 8
                    ? null
                    : 'Enter a Valid Email';
              },
              onChanged: (_input) {
                setState(() {
                  _email = _input;
                });
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
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              validator: (_input) {
                _check_password = _input;
                return _input.length == 6 && _input.length < 7
                    ? 'Use at least 7 Characters'
                    : null;
              },
              onChanged: (_input) {
                setState(() {
                  _password = _input;
                });
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
          Padding(
            padding: EdgeInsets.only(top: 23.0),
            child: TextFormField(
              validator: (_input) {
                if (_check_password != _input.toString()) {
                  return "Password are not Identical";
                } else {
                  return _input.length == 6 && _input.length < 7
                      ? 'Use at least 7 Characters'
                      : null;
                }
              },
              onChanged: (_input) {
                setState(() {
                  _check_password = _input;
                });
              },
              obscureText: isObsecure,
              controller: confPassCont,
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
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: MaterialButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              onPressed: () async {
                register();
              },
              child:
                  isloading ? CupertinoActivityIndicator() : Text('Register'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              ),
              child: Text('Already a User? Login'),
            ),
          ),
        ],
      ),
    );
  }
}
