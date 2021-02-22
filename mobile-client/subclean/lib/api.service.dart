import 'dart:convert';

import 'user.dart' as global;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  static final url = "http://192.168.1.24:3000"; //TODO: Set your pc ip here


  static Future<int> postRegister({@required String firstname, @required String lastname, @required String email, @required String password}) async {
    print('$firstname $lastname $email $password');
    final http.Response response = await http.post('$url/v1/users', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    }, body: jsonEncode(<String, dynamic>{
      'firstName': firstname,
      'lastName': lastname,
      'email': email,
      'password': password,
      }));

    print(response.body);
    return response.statusCode;
  }

  static Future<int> postSignIn({@required String email, @required String password}) async {
    print('$email $password');
    final http.Response response = await http.post('$url/v1/users/auth', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    }, body: jsonEncode(<String, dynamic>{
      'email': email,
      'password': password,
    }));

    if (response.statusCode == 200) {
      global.user = Users.fromJson(json.decode(response.body));
      return 200;
    } else {
      return response.statusCode;
    }
  }
}

class Users {
  String firstName;
  String lastName;
  String email;
  String token;

  Users({this.firstName, this.lastName, this.email, this.token});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        token: json['token']
    );
  }
}
