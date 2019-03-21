import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutterexample/src/repositories/repositories.dart';
import 'package:flutterexample/src/models/models.dart';

abstract class IcoEvent extends Equatable {
  IcoEvent([List props = const []]) : super(props);
}

class FetchIco extends IcoEvent {
}

abstract class IcoState extends Equatable {
  IcoState([List props = const []]) : super(props);
}

class IcoEmpty extends IcoState {}

class IcoLoading extends IcoState {}

class IcoLoaded extends IcoState {
  final List<Ico> icos;

  IcoLoaded({@required this.icos})
      : assert(icos != null),
        super([icos]);
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
      yield IcoLoading();
      try {
        final List<Ico> icos = await icoRepository.getIco();
        yield IcoLoaded(icos: icos);
      } catch (_) {
        yield IcoError();
      }
    }
  }
}