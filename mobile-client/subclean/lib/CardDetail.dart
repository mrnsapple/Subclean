import 'package:SubClean/trello.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user.dart' as global;

class CardDetailPage extends StatefulWidget {
  final MyCard card;
  final BuildContext oldcontext;

  CardDetailPage({this.card, this.oldcontext}) : super();

  @override
  _CardDetailPage createState() => _CardDetailPage(card: this.card, oldcontext: oldcontext);
}

class _CardDetailPage extends State<CardDetailPage> {
  final MyCard card;
  final BuildContext oldcontext;

  _CardDetailPage({this.card, this.oldcontext});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "SubClean",
        theme: global.config.theme == "dark"
            ? ThemeData.dark()
            : ThemeData.light(),
        home: Scaffold(
          appBar: AppBar(
            title: Text("Issue detail"),
          ),
          body: CardDetail(card: this.card, oldcontext: oldcontext),
        ));
  }
}

class CardDetail extends StatefulWidget {
  final MyCard card;
  final BuildContext oldcontext;

  CardDetail({this.card, this.oldcontext});

  @override
  CardDetailState createState() {
    return CardDetailState(card: this.card, oldcontext: this.oldcontext);
  }
}

class CardDetailState extends State<CardDetail> {
  MyCard card;
  bool editingMode = false;
  final BuildContext oldcontext;


  CardDetailState({@required this.card, this.oldcontext});

  String id;
  String title;
  String description;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Trello.getCardDetails(card: card).then((card) {
      this.card = card;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return editingMode ? getEditForm() : getDetails();
  }

  Widget getEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: false,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              this.editingMode = false;
              this.title = "";
              this.description = "";
              setState(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (text) {
                this.title = text;
              },
              keyboardType: TextInputType.text,
              maxLines: 1,
              initialValue: this.title,
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
              initialValue: this.description,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Description'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Processing Data'),
                        duration: Duration(seconds: 10)));
                    bool success = await Trello.putCard(
                        card: this.card,
                        desc: this.description,
                        name: this.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    if (success) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Data sent'),
                          duration: Duration(seconds: 4)));
                      this.title = "";
                      this.description = "";
                      Navigator.pop(this.oldcontext);
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
                child: Text('Send modification'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDetails() {
    return ListView(
      shrinkWrap: false,
      children: getDetailsContent(),
    );
  }

  List<Widget> getLabels() {
    List<Widget> test;
    test = this.card.labels.map((e) {
      print(e);
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            e["name"],
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            color: getColors(e["color"]),
          ),
        ),
      );
    }).toList();

    return test;
  }

  getColors(color) {
    switch (color) {
      case "purple":
        return Colors.purple;
      case "red":
        return Colors.red;
      case "yellow":
        return Colors.yellow;
      case "sky":
        return Colors.lightBlue;
      case "blue":
        return Colors.blue;
      case "pink":
        return Colors.pink;
      case "orange":
        return Colors.orange;
      case "black":
        return Colors.black;
      case "lime":
        return Colors.lime;
    }
  }

  getDetailsContent() {
    var tmp = [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          this.editingMode = true;
          this.title = this.card.title;
          this.description = this
              .card
              .desc
              .replaceAll('\n\n\n Created by ${global.user.email}', '');
          print(description.contains('\n\n\n Created by ${global.user.email}'));
          setState(() {});
        },
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Center(
                child: Text(
          this.card.title,
          style: TextStyle(fontSize: 24),
        ))),
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Center(
                child: Text(this.card.desc.replaceAll(
                    '\n\n\n Created by ${global.user.email}', '')))),
      ),
      Divider()
    ];
    tmp.addAll(getLabels());
    print(card.cover);
    if (card.cover != null) {
      tmp.add(Container(
        padding: EdgeInsets.all(8.0),
        child: Image.network(card.cover["url"],),
      ));
    }
    return tmp;
  }
}
