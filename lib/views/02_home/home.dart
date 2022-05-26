// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:control_dashboard/core/view_models/02_home/home_view_model.dart';
import 'package:control_dashboard/views/02_home/search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.carIndex}) : super(key: key);
  final int carIndex;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // camera
  CameraController? _cameraController;
  Future<void>? _initCameraControllerFuture;
  int cameraIndex = 0;
  bool isCapture = false;
  File? captureImage;
  String captureUrl = '';
  Timer? _cameraTimer;

  // webview
  void Function(JavascriptMessage)? onTapMarker;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController _myController;
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    permission();
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    // 카메라 생명주기 : dispose
    _cameraController!.dispose();
    _cameraTimer?.cancel();
    _locationTimer?.cancel();
  }

  final homeViewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Control-Dashboard'),
            GestureDetector(
              onTap: () async {
                await homeViewModel.postDriving(widget.carIndex);
              },
              child: Container(
                width: 50,
                height: 50,
                color: Colors.orange,
                child: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        // centerTitle: true,
      ),
      body: Column(
        children: [
          _webview(),
          _locationControlButton(),
          _dataMonitoring(),
          _cameraControlButton(),
        ],
      ),
    );
  }

  Widget _webview() {
    return Expanded(
      child: WebView(
        // initialUrl: 'https://foreverspring98.com/map_match/custom_index.html',
        initialUrl: 'http://175.197.91.20:5000',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _myController = webViewController;
        },
        javascriptChannels: {
          JavascriptChannel(
              name: 'onTapMarker',
              onMessageReceived: (message) {
                print(message.message);
              }),
          JavascriptChannel(
              name: 'mouseTouch',
              onMessageReceived: (message) {
                print(message.message);
              }),
        },
        debuggingEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory(() => EagerGestureRecognizer()),
        },
      ),
    );
  }

  Widget _locationControlButton() {
    return Row(
      children: [
        Expanded(child: _startButton()),
        Expanded(child: _stopButton()),
      ],
    );
  }

  double drivingSpeed = 0;
  int drivingTime = 0;
  double drivingDistance = 0;

  Widget _dataMonitoring() {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: 100,
            height: 70,
            color: Colors.indigo,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text('주행거리 : ${drivingDistance.toStringAsFixed(2)} m',
                            style: TextStyle(color: Colors.white)),
                        Text(
                            '차량속도 : ${(drivingSpeed * 3.6).toStringAsFixed(0)} km/h',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        Text('주행시간 : $drivingTime 초',
                            style: TextStyle(color: Colors.white)),
                        Text('차량정보 : 123가 5678',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _cameraControlButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 얘는 Expanded 아님
        _cameraPreview(),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              await cameraCapture();
              // /// 후면 카메라 <-> 전면 카메라 변경
              // cameraIndex = cameraIndex == 0 ? 1 : 0;
              // await _initCamera();
            },
            child: Container(
              alignment: Alignment.center,
              height: 70,
              color: Colors.red,
              child: Text('1장촬영', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              _cameraTimer =
                  Timer.periodic(Duration(seconds: 2), (timer) async {
                await cameraCapture();
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 70,
              color: Colors.orangeAccent,
              child: Text('자동촬영', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              _cameraTimer?.cancel();
            },
            child: Container(
              alignment: Alignment.center,
              height: 70,
              color: Colors.yellow,
              child: Text('촬영중지', style: TextStyle(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _startButton() {
    return GestureDetector(
      onTap: () async {
        await startButtonClicked();
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 70,
        child: Text(
          'GPS 측정 시작',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
      ),
    );
  }

  Widget _stopButton() {
    return GestureDetector(
      onTap: () async {
        _locationTimer?.cancel();
      },
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 70,
        child: Text(
          'GPS 측정 중지',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black,
      ),
    );
  }

  Widget _cameraPreview() {
    return FutureBuilder<void>(
      future: _initCameraControllerFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: 70,
            width: 70,
            child: AspectRatio(
              aspectRatio: 1 / _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> cameraCapture() async {
    try {
      await _cameraController!.takePicture().then((value) {
        captureImage = File(value.path);
        print('❤️ ${value.path}');
        captureUrl = value.path;
      });

      /// 화면 상태 변경 및 이미지 저장
      setState(() {
        isCapture = true;
      });
    } catch (e) {
      print("$e");
    }

    GallerySaver.saveImage(captureUrl)
        .then((value) => print('>>>> save value= $value'))
        .catchError((err) {
      print('error :( $err');
    });
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.veryHigh);
    _initCameraControllerFuture = _cameraController!.initialize().then((value) {
      setState(() {});
    });
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<void> permission() async {
    await [Permission.camera, Permission.storage, Permission.location]
        .request();
  }

  Future<void> startButtonClicked() async {
    /// 5개 씩 뽑아서 평균내는 테스트 진행 하면 될 듯?
    List<double> longitudeList = [];
    List<double> latitudeList = [];
    List<double> speedList = [];

    int count = 1;
    double preLongitude = 0;
    double preLatitude = 0;

    _locationTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      Position position = await getCurrentLocation();
      double longitude = position.longitude;
      double latitude = position.latitude;
      double speed = position.speed;

      longitudeList.add(longitude);
      latitudeList.add(latitude);
      speedList.add(speed);

      print(
          'raw -> count : $count, 경도 : $longitude , 위도 : $latitude, 속도 : $speed');

      if (count >= 5) {
        double sumLongitude = 0;
        double sumLatitude = 0;
        double sumSpeed = 0;

        for (int i = 0; i < longitudeList.length; i++) {
          sumLongitude += longitudeList[i];
        }
        for (int i = 0; i < latitudeList.length; i++) {
          sumLatitude += latitudeList[i];
        }
        for (int i = 0; i < speedList.length; i++) {
          sumSpeed += speedList[i];
        }

        longitudeList.removeAt(0);
        latitudeList.removeAt(0);
        speedList.removeAt(0);

        double distance = Geolocator.distanceBetween(
            preLatitude, preLongitude, sumLatitude / 5, sumLongitude / 5);

        /// 전역변수에 접근해서 setState 하는 구간
        setState(() {
          // 초항(5번째 부터 6번째가 될 때) lat, lng 값이 0,0 으로 초기화 되기때문에 현재 거리와 큰 차이를 보이므로 그 값을 빼주고
          // 자동차의 속력이 5km/h 보다 작으면 거리를 더하지 않는다.
          if (count >= 6 && (sumSpeed / 5) * 3.6 > 5) {
            drivingDistance += distance;
          }
          drivingSpeed = sumSpeed / 5;
          drivingTime += 2;
        });

        await _myController.runJavascript(
            'appToWeb("${sumLongitude / 5}", "${sumLatitude / 5}", "$longitude", "$latitude", "$preLongitude", "$preLatitude")');
        preLongitude = sumLongitude / 5;
        preLatitude = sumLatitude / 5;
        print(
            'filtered -> count : ❤️, 경도 : ${sumLongitude / 5} , 위도 : ${sumLatitude / 5}, 속도 : ${sumSpeed / 5}, 거리 : $distance');
        // count = 0;
      }
      count++;
    });
  }
}
