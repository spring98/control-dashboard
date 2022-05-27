class DataModel {
  final String colecDt;
  final String lat;
  final String lng;

  DataModel({
    required this.colecDt,
    required this.lat,
    required this.lng,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      colecDt: json['colec_dt'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
