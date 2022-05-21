// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      home: CameraExample(),
    ),
  );
}

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  CameraController? _cameraController;
  Future<void>? _initCameraControllerFuture;
  int cameraIndex = 0;

  bool isCapture = false;
  File? captureImage;
  String captureUrl = '';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    // 카메라 생명주기 : dispose
    _cameraController!.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _cameraPreview(),
          _cameraControlButton(),
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    return FutureBuilder<void>(
      future: _initCameraControllerFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: 100,
            height: 100,
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

  Widget _cameraControlButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await cameraCapture();
            // /// 후면 카메라 <-> 전면 카메라 변경
            // cameraIndex = cameraIndex == 0 ? 1 : 0;
            // await _initCamera();
          },
          child: Container(
            alignment: Alignment.center,
            height: 120,
            width: 120,
            color: Colors.yellow,
            child: Text('캡처하기'),
          ),
        ),
        GestureDetector(
          onTap: () async {
            _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
              await cameraCapture();
            });
          },
          child: Container(
            alignment: Alignment.center,
            height: 120,
            width: 120,
            color: Colors.orangeAccent,
            child: Text('촬영시작'),
          ),
        ),
        GestureDetector(
          onTap: () async {
            _timer?.cancel();
          },
          child: Container(
            alignment: Alignment.center,
            height: 120,
            width: 120,
            color: Colors.pinkAccent,
            child: Text('촬영중지'),
          ),
        ),
      ],
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
}
