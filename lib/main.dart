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

  ///
  // String url = '';
  // String imagePath = '';
  // final ImagePicker _picker = ImagePicker();
  ///

  // Future<String> getPicker() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   print('======================= In getPicker()==================');
  //   if (image != null) {
  //     // print('getPicker image not null entered ! ');
  //     // print(image.path);
  //     return image.path;
  //   } else {
  //     return '';
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[cameraIndex], ResolutionPreset.veryHigh);
    _initCameraControllerFuture = _cameraController!.initialize().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
        centerTitle: true,
      ),
      body: isCapture
          ? Column(
              children: [
                /// 촬영 된 이미지 출력
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: Container(
                    width: size.width,
                    height: size.width,
                    child: ClipRect(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: size.width,
                          child: AspectRatio(
                            aspectRatio:
                                1 / _cameraController!.value.aspectRatio,
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: MemoryImage(
                                    captureImage!.readAsBytesSync()),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          /// 재촬영 선택시 카메라 삭제 및 상태 변경
                          captureImage!.delete();
                          captureImage = null;
                          setState(() {
                            isCapture = false;
                          });
                        },
                        child: Container(
                          color: Colors.yellow,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "다시 찍기",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('하이');

                          GallerySaver.saveImage(captureUrl)
                              .then((value) => print('>>>> save value= $value'))
                              .catchError((err) {
                            print('error :( $err');
                          });
                        },
                        child: Container(
                          color: Colors.orangeAccent,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "저장하기",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: FutureBuilder<void>(
                    future: _initCameraControllerFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: size.width,
                          height: size.width,
                          child: ClipRect(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: SizedBox(
                                width: size.width,
                                child: AspectRatio(
                                    aspectRatio: 1 /
                                        _cameraController!.value.aspectRatio,
                                    child: CameraPreview(_cameraController!)),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              await _cameraController!
                                  .takePicture()
                                  .then((value) {
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
                          },
                          child: Container(
                            height: 80.0,
                            width: 80.0,
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                              color: Colors.white,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 3.0),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () async {
                              // print('사진등록 선택');
                              //
                              // String url = await getPicker();
                              // if (url.isNotEmpty) {
                              //   print('🧡 : $url');
                              // }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () async {
                              /// 후면 카메라 <-> 전면 카메라 변경
                              cameraIndex = cameraIndex == 0 ? 1 : 0;
                              await _initCamera();
                            },
                            icon: Icon(
                              Icons.flip_camera_android,
                              color: Colors.white,
                              size: 34.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
