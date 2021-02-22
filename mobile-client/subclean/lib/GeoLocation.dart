import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<List<ListItem>> _getCurrentLocation() async{
  List<ListItem> items = new List<ListItem>();
  Position position =  await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);    //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<Placemark> pl =  await placemarkFromCoordinates(position.latitude, position.longitude); 
  
  for(var i=0;i<pl.length;i++){ 
    try {
      items.add(MessageItem(pl[i].street + "," + pl[i].name ,
                    pl[i].postalCode + "," + pl[i].locality + "," + pl[i].subAdministrativeArea));
    } on Exception catch (_) {
    }
  }
  print("ITEMS:");
  print(items);
  return items;
}

class Location extends StatelessWidget {

  Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) 
  {
    final title = 'Add Location';
    var items = snapshot.data;
    print("ITEMS:");
    print(items);

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              onTap:() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage.location( item),
                ),
              ),
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  
  }
  Location({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Row(children: [
        Expanded(
          child: FutureBuilder(
              future: _getCurrentLocation(),
              initialData: [],
              builder: (context, snapshot) {
                return createCountriesListView(context, snapshot);
              }),
        ),
      ]),
    );
    
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}