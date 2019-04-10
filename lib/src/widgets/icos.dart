import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutterexample/src/repositories/repositories.dart';
import 'package:flutterexample/src/blocs/blocs.dart';

class Icos extends StatefulWidget {
  final IcoRepository icoRepository;

  Icos({Key key, @required this.icoRepository})
      : assert(icoRepository != null),
        super(key: key);

  @override
  State<Icos> createState() => _IcoState();
}

class _IcoState extends State<Icos> {
  IcoBloc _icoBloc;
  var timer;

  _initInterval(bool loop) {
    if (loop == false) {
      _icoBloc.dispatch(FetchIco(1));
      timer = Timer.periodic(new Duration(seconds: 10), (timer) {
        _icoBloc.dispatch(FetchIco(1));
      });
    } else {
      timer.cancel();
      _icoBloc.dispatch(StopFetchIco());
    }
  }

  @override
  void initState() {
    super.initState();
    _icoBloc = IcoBloc(icoRepository: widget.icoRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryto Currency'),
      ),
      body: BlocBuilder(
        bloc: _icoBloc,
        builder: (_, IcoState state) {
          if (state is IcoEmpty) {
            return Center(child: Text('Vacio...'));
          }
          if (state is IcoLoaded) {
            return buildList(state);
          }
        }
      ),
      floatingActionButton: BlocBuilder(
        bloc: _icoBloc,
        builder: (_, IcoState state) {
          return FloatingActionButton(
                  onPressed: () { _initInterval(state.loop); },
                  child: Icon(state.loop == false ? Icons.play_arrow : Icons.stop),
                );
        }
      ),
    );
  }

  bool notNull(Object o) => o != null;

  Widget buildList(IcoLoaded state) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if(index < state.icos.length) {
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              leading: Icon(Icons.flight_land),
              title: Text(state.icos[index].name),
              subtitle: Text(state.icos[index].priceUsd.toString()),
            )
          );
        }
        if(index == state.icos.length) {
          _icoBloc.dispatch(FetchIco(state.icos.length ~/ 10 + 1));
          return defaultLoading();
        }
        return null;
      },
    );
  }

  Widget defaultLoading() {
    return Align(
      child: SizedBox(
        height: 40,
        width: 40,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _icoBloc.dispose();
    super.dispose();
  }
}
