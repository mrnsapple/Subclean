import 'package:SubClean/CardDetail.dart';
import 'package:SubClean/trello.service.dart';
import 'package:flutter/material.dart';
import 'user.dart' as global;

class CardPage extends StatefulWidget {
  CardPage() : super();

  @override
  _CardPage createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SubClean",
      theme: global.config.theme == "dark" ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            title: Text("My issues"),
          ),
          body: CardList()),
    );
  }
}

class CardList extends StatefulWidget {
  @override
  CardListState createState() {
    return CardListState();
  }
}

class CardListState extends State<CardList> {
  String table = "5f7114be0e881267baedaa1e";
  List<MyCard> cards = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
    Trello.getCards().then((value) {
      cards = value;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        DropdownButton<String>(
            isExpanded: true,
            value: table,
            onChanged: (String newValue) async {
              setState(() {
                table = newValue;
              });
              cards = await Trello.getCards(table: newValue);
              setState(() {});
            },
            items: [
              DropdownMenuItem<String>(
                value: "5f7114be0e881267baedaa1e",
                child: Center(
                  child: Text("Not filtered"),
                ),
              ),
              DropdownMenuItem<String>(
                  value: "5f69b647ea77ac2d28208854",
                  child: Center(child: Text("To Do"))),
              DropdownMenuItem<String>(
                  value: "5f69b647f7e23f2be2f8fa92",
                  child: Center(child: Text("Doing"))),
              DropdownMenuItem<String>(
                  value: "5f69b64788402959ac865814",
                  child: Center(child: Text("Done/Closed"))),
            ]),
      ]..addAll(getAllCards(cards)),
    );
  }

  Widget getACard(MyCard card) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: Colors.black12)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute( builder: (context) => CardDetailPage(card: card, oldcontext: context),),);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 75,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        card.title,
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 22,
                      ),
                      onPressed: table == "5f7114be0e881267baedaa1e"
                          ? card.desc
                                  .contains('\n\n\n Created by ${global.user.email}')
                              ? () {
                                  _deleteCard(card);
                                }
                              : null
                          : null,
                      disabledColor: table == "5f7114be0e881267baedaa1e"
                          ? Colors.grey
                          : Colors.transparent,
                    ),
                  )
                ],
              ),
              Divider(
                height: 1.5,
                thickness: 0.75,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  card.desc.replaceAll('\n\n\n Created by ${global.user.email}', ''),
                  style: TextStyle(fontStyle: FontStyle.italic),
                )),
              ),
            ],
          )),
    );
  }

  List<Widget> getAllCards(List<MyCard> cards) {
    List<Widget> myCardWidget = cards.map((e) => getACard(e)).toList();
    myCardWidget.removeWhere((element) => element == null);
    return myCardWidget;
  }

  _deleteCard(MyCard card) {
    BuildContext tmpContext;

    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(tmpContext);
      },
    );

    Widget confirmButton = FlatButton(
      child: Text('Confirm'),
      onPressed: () async {
        await Trello.deleteCard(card: card);
        this.cards = await Trello.getCards(table: this.table);
        setState(() {});
        Navigator.pop(tmpContext);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete issue"),
      content: RichText(
        text: TextSpan(
          text: "Do you really want to delete the issue\n",
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: card.title, style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ),
      actions: [cancelButton, confirmButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          tmpContext = context;
          return alert;
        });
  }
}
