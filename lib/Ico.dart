class Ico {
  final String name;
  final String priceUsd;

  Ico({this.name, this.priceUsd});

  factory Ico.fromJson(Map<String, dynamic> json) {
    return Ico(name: json['name'], priceUsd: json['price_usd']);
  }
}
