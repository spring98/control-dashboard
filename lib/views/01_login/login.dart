import 'package:control_dashboard/core/view_models/01_login/login_view_model.dart';
import 'package:control_dashboard/models/car/car_model.dart';
import 'package:control_dashboard/views/02_home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginViewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _carList(),
          ],
        ),
      ),
    );
  }

  Widget _carList() {
    return FutureBuilder<List<CarModel>>(
        future: loginViewModel.fetchCars(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                for (int i = 0; i < snapshot.data!.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      Get.to(() => Home(carIndex: i));
                    },
                    child: Container(
                      width: 300,
                      height: 100,
                      color: Colors.lightBlueAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('car id : ${snapshot.data![i].carId}'),
                          Text('car no : ${snapshot.data![i].carNo}'),
                          Text('car nm : ${snapshot.data![i].carNm}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ]
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
