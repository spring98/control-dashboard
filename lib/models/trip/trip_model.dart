class TripModel {
  final String carId;
  final String? carNo;
  final String? carNm;
  final String tripSeq;
  final String? startDt;
  final String? endDt;
  final String stLat;
  final String stLng;
  final String? finLat;
  final String? finLng;
  final String createdAt;
  final String updateAt;

  TripModel({
    required this.carId,
    required this.carNo,
    required this.carNm,
    required this.tripSeq,
    required this.startDt,
    required this.endDt,
    required this.stLat,
    required this.stLng,
    required this.finLat,
    required this.finLng,
    required this.createdAt,
    required this.updateAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      carId: json['car_id'],
      carNo: json['car_no'],
      carNm: json['car_nm'],
      tripSeq: json['trip_seq'],
      startDt: json['start_dt'],
      endDt: json['end_dt'],
      stLat: json['st_lat'],
      stLng: json['st_lng'],
      finLat: json['fin_lat'],
      finLng: json['fin_lng'],
      createdAt: json['created_at'],
      updateAt: json['updated_at'],
    );
  }
}
