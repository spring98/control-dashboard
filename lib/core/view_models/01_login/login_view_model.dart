import 'dart:convert';

import 'package:control_dashboard/core/services/car/car_service.dart';
import 'package:control_dashboard/models/car/car_model.dart';
import 'package:get/get.dart';

class LoginViewModel extends GetxController {
  final CarService _carService = CarService();

  List<CarModel> carModels = [];

  Future<List<CarModel>> fetchCars() async {
    carModels = [];
    var result = jsonDecode(await _carService.fetchCars())['result'];

    for (int i = 0; i < result.length; i++) {
      carModels.add(CarModel.fromJson(result[i]));
    }

    return carModels;
  }

  List<CarModel> getCarModels() {
    return carModels;
  }
}
