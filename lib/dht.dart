class DHT {
  final double temp;
  final double humidity;
  final double heatIndex;

  DHT({this.temp, this.humidity, this.heatIndex});

  factory DHT.fromJson(Map<dynamic, dynamic> json) {
    double parser(dynamic source) {
      try {
        return double.parse(source.toString());
      } on FormatException {
        return -1;
      }
    }

    return DHT(
        temp: parser(json['double']),
        humidity: parser(json['nem']),
        heatIndex: parser(json['gecmis']));
  }

  get temperatureHistory => null;
}
