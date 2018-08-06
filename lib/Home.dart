import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import './Ico.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.https('api.coinmarketcap.com', 'v1/ticker');
  final httpClient = HttpClient();
  List<Ico> _icos;

  Future<List<Ico>> _getIPAddress() async {
    var request = await httpClient.getUrl(url);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    List items = json.decode(responseBody);
    _icos = new List<Ico>();
    for (var item in items) {
      Ico ico = Ico.fromJson(item);
      _icos.add(ico);
    }
    return _icos;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: new FutureBuilder<List<Ico>>(
        future: _getIPAddress(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return new ListView(
                  children: snapshot.data
                      .map<Widget>((ico) => new ListTile(
                            title: new Text(ico.name),
                            subtitle: new Text(ico.priceUsd),
                          ))
                      .toList());
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      )),
    );
  }
}
