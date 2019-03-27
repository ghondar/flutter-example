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
      _icoBloc.dispatch(FetchIco());
      timer = Timer.periodic(new Duration(seconds: 10), (timer) {
        _icoBloc.dispatch(FetchIco());
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
      body: Center(
        child: BlocBuilder(
          bloc: _icoBloc,
          builder: (_, IcoState state) {
            if (state is IcoEmpty) {
              return Center(child: Text('Vacio...'));
            }
            if (state is IcoLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is IcoLoaded) {
              return Scrollbar(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.all(20.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          state.icos
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
              );
            }
          }
        ),
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



  @override
  void dispose() {
    _icoBloc.dispose();
    super.dispose();
  }
}
