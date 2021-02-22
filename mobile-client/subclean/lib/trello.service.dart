import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart' as global;

class Trello {
  static final url = "https://api.trello.com";
  static final key = "67536e4bb29fd5df879a4c72aa296513";
  static final token =
      "467cd7b4778c93efa0da67a7672e6f0c2f82757d5546566da3bfe3f92bf3e36a";
  static final board = "5f69b6468e14103a49487003";
  static final list = "5f7114be0e881267baedaa1e";

  static Future<List<MyCard>> getCards(
      {String table = "5f7114be0e881267baedaa1e"}) async {
    final http.Response response =
        await http.get('$url/1/lists/$table/cards?key=$key&token=$token');
    List<MyCard> cards = (json.decode(response.body) as List)
        .map((i) => MyCard.fromJson(i))
        .toList();
    cards.removeWhere((element) => element == null);
    return cards;
  }

  static Future<bool> postCard(
      {@required String desc,
      @required String name,
      List<String> labels,
      File photo}) async {
    final http.Response response = await http.post(
        '$url/1/cards?key=$key&token=$token&idList=$list',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'desc': desc + "\n\n\n Created by ${global.user.email}",
          'name': name,
          'idLabels': labels
        }));

    if (response.statusCode == 200) {
      final responseTrello = ResponseTrello.fromJson(jsonDecode(response.body));

      if (photo != null) {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                '$url/1/cards/${responseTrello.id}/attachments?key=$key&token=$token'));
        request.files.add(http.MultipartFile.fromBytes(
            'file', photo.readAsBytesSync(),
            filename: photo.path.split("/").last));
        var res = await request.send();
        if (res.statusCode != 200) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  static Future<bool> deleteCard({@required MyCard card}) async {
    final http.Response response = await http.delete('$url/1/cards/${card.id}/?key=$key&token=$token');
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  static Future<bool> putCard(
      {@required MyCard card, @required String desc,
        @required String name}) async {
    final http.Response response = await http.put(
        '$url/1/cards/${card.id}?key=$key&token=$token',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{
          'desc': desc + "\n\n\n Created by ${global.user.email}",
          'name': name
        }));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<MyCard> getCardDetails({@required MyCard card}) async {
    final http.Response response = await http.get(
        '$url/1/cards/${card.id}?key=$key&token=$token',
        headers: <String, String>{
          'Accept': 'application/json'
        });

    if (response.statusCode == 200) {
      return MyCard.fromJson(json.decode(response.body));
    }
    return null;
  }
}

class ResponseTrello {
  String id;

  ResponseTrello({this.id});

  factory ResponseTrello.fromJson(Map<String, dynamic> json) {
    return ResponseTrello(id: json["id"]);
  }
}

class MyCard {
  String id;
  String title;
  String desc;
  List<dynamic> labels;
  Map<String, dynamic> cover;

  MyCard({this.id, this.title, this.desc, this.labels, this.cover});

  factory MyCard.fromJson(Map<String, dynamic> json) {
    if (json["desc"].toString().contains('\n\n\n Created by ${global.user.email}')) {
      if (json["cover"] != null && json["cover"]["scaled"] != null && json["cover"]["scaled"][0] != null) {
        Map<String, dynamic> cover = Map<String, dynamic>();
        cover["bytes"] = 0;
        json["cover"]["scaled"].forEach((e) {
          if (e["bytes"] > cover["bytes"])
            cover = e;
        });
        return MyCard(id: json['id'], title: json['name'], desc: json['desc'], labels: json["labels"], cover: cover);
      } else
        return MyCard(id: json['id'], title: json['name'], desc: json['desc'], labels: json["labels"]);
    }
    return null;
  }
}
