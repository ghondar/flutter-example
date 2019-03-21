import 'package:equatable/equatable.dart';

class Ico extends Equatable {
  final String name;
  final String priceUsd;

  Ico({ this.name, this.priceUsd, }) : super([ name, priceUsd, ]);

  static Ico fromJson(dynamic json) {
    return Ico(
      name: json['name'], priceUsd: json['price_usd']
    );
  }
}