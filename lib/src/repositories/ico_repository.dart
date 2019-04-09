import 'package:meta/meta.dart';

import 'package:flutterexample/src/repositories/ico_api_client.dart';
import 'package:flutterexample/src/models/models.dart';

class IcoRepository {
  final IcoApiClient icoApiClient;

  IcoRepository({@required this.icoApiClient})
      : assert(icoApiClient != null);

  Future<List<Ico>> getIco(int page) async {
    return icoApiClient.fetchIco(page);
  }
}