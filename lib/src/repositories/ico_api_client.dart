import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:flutterexample/src/models/models.dart';

class IcoApiClient {
  static const baseUrl = 'https://pro-api.coinmarketcap.com';
  static const token = '0bcf7906-967f-431d-8b21-f6621781ad7b';
  final http.Client httpClient;  

  IcoApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<List<Ico>> fetchIco(int page) async {
    final icoUrl = '$baseUrl/v1/cryptocurrency/listings/latest?limit=10&start=${(page - 1) * 10 + 1}';
    print(icoUrl);
    final icoResponse = await this.httpClient.get(icoUrl, headers: { 'X-CMC_PRO_API_KEY': token});

    if (icoResponse.statusCode != 200) {
      print(icoResponse.statusCode);
      throw Exception('error getting ico for location');
    }

    final items = jsonDecode(icoResponse.body);
    final icos = new List<Ico>();

    for (var item in items['data']) {
      Ico ico = Ico.fromJson(item);
      icos.add(ico);
    }

    return icos;
  }
}