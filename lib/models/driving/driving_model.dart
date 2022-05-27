import 'package:control_dashboard/models/driving/data_model.dart';

class DrivingModel {
  final String carId;
  final String tripSeq;
  final List<DataModel> data;

  DrivingModel({
    required this.carId,
    required this.tripSeq,
    required this.data,
  });

  factory DrivingModel.fromJson(Map<String, dynamic> json) {
    return DrivingModel(
      carId: json['car_id'],
      tripSeq: json['trip_seq'],
      data: json['data']?.cast<DataModel>(),
    );
  }
}

// List<String> datas;
// final tags = record['tags']?.cast<String>() ;
// if (tags != null) {
// datas = tags;
// }
