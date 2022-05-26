import 'package:control_dashboard/core/services/car/driving_service.dart';
import 'package:control_dashboard/core/view_models/01_login/login_view_model.dart';
import 'package:control_dashboard/models/car/car_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final DrivingService _drivingService = DrivingService();
  final LoginViewModel _loginViewModel = Get.put(LoginViewModel());

  // String carId, String tripSeq, int onOff,
  //     String colecDt, String lat, String lng

  Future<void> postDriving(int index) async {
    List<CarModel> carModels = _loginViewModel.getCarModels();
    print('🚐');
    print(carModels);
    print(DateTime.now().toString());

    await _drivingService.postDriving(
      carId: carModels[index].carId,
      tripSeq: DateTime.now().toString().split('.')[0],
      onOff: 1,
      colecDt:
          DateTime.now().add(Duration(seconds: 1)).toString().split('.')[0],
      lat: '37.47838832',
      lng: '126.8835098',
    );
  }
}
