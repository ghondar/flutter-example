import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import './Ico.dart';
import './Icos.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.https('api.coinmarketcap.com', 'v1/ticker');
  final httpClient = HttpClient();
  Icos _icos = new Icos(new List<Ico>(), 'New');

  _getIcos() async {
    try {
      setState(() {
        _icos.changeState('Loading');
      });
      var request = await httpClient.getUrl(url);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      List items = json.decode(responseBody);
      for (var item in items) {
        Ico ico = Ico.fromJson(item);
        setState(() {
          _icos.addCoin(ico);
        });
      }
      setState(() {
        _icos.changeState('Done');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _icos.state == 'New'
            ? Text('Vacio...')
            : _icos.state == 'Loading'
                ? CircularProgressIndicator()
                : Scrollbar(
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: EdgeInsets.all(20.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              _icos.icos
                                  .map<Widget>((ico) => ListTile(
                                        leading: Icon(Icons.flight_land),
                                        title: Text(ico.name),
                                        subtitle: Text(ico.priceUsd),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getIcos,
        child: const Icon(Icons.add),
      ),
    );
  }
}
