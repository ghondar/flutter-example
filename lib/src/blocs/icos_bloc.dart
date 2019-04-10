import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutterexample/src/repositories/repositories.dart';
import 'package:flutterexample/src/models/models.dart';

abstract class IcoEvent extends Equatable {
  IcoEvent([List props = const []]) : super(props);
}

class FetchIco extends IcoEvent {
  int page;
  FetchIco(this.page);
}

class StopFetchIco extends IcoEvent {
}

abstract class IcoState extends Equatable {
  final bool loop = false;
  IcoState([List props = const [], bool loop = false]) : super(props);
}

class IcoEmpty extends IcoState {
  final bool loop = false;
}

class IcoLoading extends IcoState {
  final bool loop;
  IcoLoading({@required this.loop})
    : assert(loop != null),
      super([loop]);
}

class IcoLoaded extends IcoState {
  final List<Ico> icos;
  final bool loop;

  IcoLoaded({@required this.icos, @required this.loop})
      : assert(icos != null, loop != null),
        super([icos, loop]);
}

class IcoError extends IcoState {}

class IcoBloc extends Bloc<IcoEvent, IcoState> {
  final IcoRepository icoRepository;

  IcoBloc({@required this.icoRepository})
      : assert(icoRepository != null);

  @override
  IcoState get initialState => IcoEmpty();

  @override
  Stream<IcoState> mapEventToState(
    IcoState currentState,
    IcoEvent event,
  ) async* {
    if (event is FetchIco) {
      yield IcoLoaded(icos: currentState.props.length > 0 ? currentState.props[0] : [],loop: true);
      try {
        final List<Ico> icos = await icoRepository.getIco(event.page);
        List<Ico> newList = []..addAll(currentState.props.length > 0 ? currentState.props[0] : [])..addAll(icos);
        yield IcoLoaded(icos: newList, loop: true);
      } catch (_) {
        yield IcoError();
      }
    } if(event is StopFetchIco) {
      yield IcoLoaded(icos: currentState.props[0], loop: false);
    }
  }
}