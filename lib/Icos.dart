import './Ico.dart';

class Icos {
  List<Ico> icos;
  String state;

  Icos(List<Ico> icos, String state) {
    this.icos = icos != null ? icos : new List<Ico>();
    this.state = state.isNotEmpty ? state : 'New';
  }

  addCoin(Ico ico) {
    icos.add(ico);
  }

  changeState(String _state) {
    state = _state;
  }
}
