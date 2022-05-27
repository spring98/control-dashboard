import 'dart:convert';

import 'package:control_dashboard/core/services/car/driving_service.dart';
import 'package:control_dashboard/core/view_models/01_login/login_view_model.dart';
import 'package:control_dashboard/models/car/car_model.dart';
import 'package:control_dashboard/models/trip/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../models/driving/driving_model.dart';
import '../../../utils/util.dart';

class HomeViewModel extends GetxController {
  final DrivingService _drivingService = DrivingService();
  final LoginViewModel _loginViewModel = Get.put(LoginViewModel());

  String tripSeqenceNow = '';
  Future<void> postDrivingOn(int index, List<Map<String, String>> data) async {
    tripSeqenceNow = DateTime.now().toString().split('.')[0];

    Position position = await Util().getCurrentLocation();
    double longitude = position.longitude;
    double latitude = position.latitude;

    Map<String, String> fragData = {
      'colec_dt': DateTime.parse(tripSeqenceNow)
          .add(Duration(seconds: 2))
          .toString()
          .split('.')[0],
      'lat': latitude.toStringAsFixed(10),
      'lng': longitude.toStringAsFixed(10),
    };

    print('👎 Flag On Response');
    // print(tripSeqenceNow);
    List<CarModel> carModels = _loginViewModel.getCarModels();

    await _drivingService.postDriving(
      carId: carModels[index].carId,
      tripSeq: tripSeqenceNow,
      onOff: 1,
      listData: [fragData],
      // colecDt:
      //     DateTime.now().add(Duration(seconds: 1)).toString().split('.')[0],
      // lat: '37.47838832',
      // lng: '126.8835098',
    );
  }

  Future<void> postDrivingOff(int index, List<Map<String, String>> data) async {
    List<CarModel> carModels = _loginViewModel.getCarModels();
    print('👎 Flag Off Response');
    // print(tripSeqenceNow);

    Position position = await Util().getCurrentLocation();
    double longitude = position.longitude;
    double latitude = position.latitude;

    Map<String, String> fragData = {
      'colec_dt': DateTime.now().toString().split('.')[0],
      'lat': latitude.toStringAsFixed(10),
      'lng': longitude.toStringAsFixed(10),
    };

    await _drivingService.postDriving(
      carId: carModels[index].carId,
      tripSeq: tripSeqenceNow,
      onOff: 0,
      listData: [fragData],
      // listData: data,

      // colecDt:
      //     DateTime.now().add(Duration(seconds: 1)).toString().split('.')[0],
      // lat: '37.47838832',
      // lng: '126.8835098',
    );
  }

  List<TripModel> tripModels = [];
  Future<List<TripModel>> fetchTrip(int index) async {
    tripModels = [];
    List<CarModel> carModels = _loginViewModel.getCarModels();
    var result = jsonDecode(await _drivingService.fetchTrip(
        carId: carModels[index].carId))['result'];
    for (int i = 0; i < result.length; i++) {
      tripModels.add(TripModel.fromJson(result[i]));
    }
    return tripModels;
  }

  List<DrivingModel> drivingModels = [];
  Future<List<DrivingModel>> fetchDriving(int index, int seqIndex) async {
    drivingModels = [];
    List<CarModel> carModels = _loginViewModel.getCarModels();
    var result = jsonDecode(await _drivingService.fetchDriving(
        carId: carModels[index].carId,
        tripSeq: tripModels[seqIndex].tripSeq))['result'];
    print('🏀');
    print(result);

    drivingModels.add(DrivingModel.fromJson(result));

    update();
    return drivingModels;
  }

  Future<void> postBlackBox(
      int index, String path, String lat, String lng) async {
    List<CarModel> carModels = _loginViewModel.getCarModels();
    var result = jsonDecode(await _drivingService.postBlackBox(
        carId: carModels[index].carId,
        path: path,
        tripSeq: tripSeqenceNow,
        lat: lat,
        lng: lng));
    print('👎 camera post');
    print(result);
  }
}
// 왜 1분 이런식으로 줘야하냐면 1초에 한번씩 request를 쐈는데 이전에 있는 데이터가 서버에는 늦게 도착할 수 있다. 그게 마지막이면, 운행 종료 마지막에서 바로 전꺼에서 운행 종료가 먼저 들어갈 수 있어서
