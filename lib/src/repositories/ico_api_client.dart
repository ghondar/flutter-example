import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:flutterexample/src/models/models.dart';

class IcoApiClient {
  static const baseUrl = 'https://api.coinmarketcap.com';
  final http.Client httpClient;  

  IcoApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Ico>> fetchIco() async {
    final icoUrl = '$baseUrl/v1/ticker';
    final icoResponse = await this.httpClient.get(icoUrl);

    if (icoResponse.statusCode != 200) {
      throw Exception('error getting ico for location');
    }

    final items = jsonDecode(icoResponse.body);
    final icos = new List<Ico>();

    for (var item in items) {
      Ico ico = Ico.fromJson(item);
      icos.add(ico);
    }

    return icos;
  }
}