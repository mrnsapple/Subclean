import 'dart:developer';

import 'package:flutter/material.dart';
import 'GetImages.dart';
import 'trello.service.dart';
import 'CardList.dart';
import 'Labels.dart';
import 'GeoLocation.dart';

import 'user.dart' as global;

class HomePage extends StatefulWidget {
  HomePage.location( this.location) : super();
  HomePage() : super();
 
    ListItem location;
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Widget locationTitle = Text('Add location');
  @override
  Widget build(BuildContext context) {
    if (widget.location != null)
        locationTitle =  widget.location.buildTitle(context);
    return MaterialApp(
      title: "Describe your problem",
      theme: global.config.theme == "dark" ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Describe your problem"),
            actions: [
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute( builder: (context) => CardPage(),),);
                },
              )
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(16.0),
            child: MyCustomForm(locationTitle),
          )),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  Widget locationtitle;

  MyCustomForm( this.locationtitle) : super();

  
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  var imageFile;
  String title;
  String description;
  List<String> labels;
  String type = "5f69b646cdabcf46c0e17d3d";

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  final options = <MultiSelectDialogItem<String>>[
    MultiSelectDialogItem("5f8cd95d58f77c5953968763", "Metro"),
    MultiSelectDialogItem("5f8cd8fb72b54e046b762d9a", "Tramway"),
    MultiSelectDialogItem("5f8cd98093c8bd806f9362de", "Bus"),
    MultiSelectDialogItem("5f8cd9ba720b0f13d20fef06", "Bicycle"),
    MultiSelectDialogItem("5f8cd9fe6b0a7b42d3ed5a29", "Traveler Incident"),
    MultiSelectDialogItem("5f8cda4b399ed1062dc4c25b", "Road Stuck"),
    MultiSelectDialogItem("5f8cda8195bd5b4c0cb2127c", "Technical Incident"),
    MultiSelectDialogItem("5f69b646cdabcf46c0e17d35", "LOW"),
    MultiSelectDialogItem("5f69b646cdabcf46c0e17d37", "NORMAL"),
    MultiSelectDialogItem("5f69b646cdabcf46c0e17d39", "HIGH"),
    MultiSelectDialogItem("5f7118321f20ba41411e3ebc", "HIGHEST"),
  ];

  final options_type = <DropdownMenuItem<String>>[
    DropdownMenuItem(value: "5f69b646cdabcf46c0e17d3d",child: Center(child: Text("COMPLAIN"))),
    DropdownMenuItem(value: "5f69b646cdabcf46c0e17d3e",child: Center(child: Text("PROPOSAL"))),
  ];

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: false,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (text) {
                this.title = text;
              },
              keyboardType: TextInputType.text,
              maxLines: 1,
              controller: _titleController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Title',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (text) {
                this.description = text;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              controller: _descController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Description'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: MaterialButton(
              color: Colors.blue,
              child: Text("Select labels"),
              onPressed: () async {
                this.labels = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MultiSelectDialog(
                      items: this.options,
                      title: 'Select labels',
                    );
                  }
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: DropdownButton<String>(
                isExpanded: true,
                value: this.type,
                onChanged: (String newValue) {
                  print(newValue);
                  this.type = newValue;
                  setState(() {});
                },
                items: options_type),
          ),
          decideImageView(imageFile: imageFile),
          //imageFile,
          Row(
            children: [
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  this.imageFile = await openGallery();
                  setState(() {});
                },
                child: Text("Gallery"),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  this.imageFile = await openCamera();
                  setState(() {});
                },
                child: Text("Camera"),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
           Padding(
            padding: EdgeInsets.only(top: 13.0),
            child: FlatButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Location(),
                ),
              ),
              child: widget.locationtitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  print(type);
                  print(options_type[0].value);
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    labels.add(type);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Processing Data'),
                        duration: Duration(seconds: 10)));
                    bool success = await Trello.postCard(
                        desc: this.description, name: this.title, labels: this.labels, photo: imageFile);
                    Scaffold.of(context).hideCurrentSnackBar();
                    if (success) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Data sent'),
                          duration: Duration(seconds: 4)));
                      _titleController.text = "";
                      _descController.text = "";
                      this.imageFile = null;
                      setState(() {});
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Cannot send data'),
                          duration: Duration(seconds: 4)));
                    }
                    // If the form is valid, display a Snackbar.
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
