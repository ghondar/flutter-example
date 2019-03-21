import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';

import 'package:flutterexample/src/widgets/widgets.dart';
import 'package:flutterexample/src/repositories/repositories.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}

void main() {
  final IcoRepository icoRepository = IcoRepository(
    icoApiClient: IcoApiClient(
      httpClient: http.Client(),
    ),
  );

  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App(icoRepository: icoRepository));
}

class App extends StatefulWidget {
  final IcoRepository icoRepository;

  App({Key key, @required this.icoRepository})
      : assert(icoRepository != null),
        super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather',
      theme: ThemeData.dark(),
      home: Icos(icoRepository: widget.icoRepository,),
    );
  }
}
