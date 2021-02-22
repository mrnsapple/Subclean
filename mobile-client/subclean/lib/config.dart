import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class Config {
  String theme = "dark";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localConfig(String configName) async {
    final path = await _localPath;
    return File('$path/config_$configName.txt');
  }

  Future<String> readTheme() async {
    try {
      final file = await _localConfig("theme");

      String content = await file.readAsString();
      this.theme = content;
      return this.theme;
    } catch (e) {
      saveTheme("dark");
      print(e);
      return "dark";
    }
  }

  Future<File> saveTheme(String theme) async {
    final file = await _localConfig("theme");
    this.theme = theme;

    // Write the file
    return file.writeAsString('$theme');
  }
}