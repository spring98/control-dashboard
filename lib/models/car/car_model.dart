class CarModel {
  final String carId;
  final String? carNo;
  final String? carNm;
  final String lat;
  final String lng;
  final int onOff;
  final String createdAt;
  final String updateAt;

  CarModel({
    required this.carId,
    required this.carNo,
    required this.carNm,
    required this.lat,
    required this.lng,
    required this.onOff,
    required this.createdAt,
    required this.updateAt,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carId: json['car_id'],
      carNo: json['car_no'],
      carNm: json['car_nm'],
      lat: json['lat'],
      lng: json['lng'],
      onOff: json['onoff'],
      createdAt: json['created_at'],
      updateAt: json['updated_at'],
    );
  }
}
