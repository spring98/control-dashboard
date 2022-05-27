import 'package:control_dashboard/core/view_models/02_home/home_view_model.dart';
import 'package:control_dashboard/models/driving/driving_model.dart';
import 'package:control_dashboard/models/trip/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  const Search({Key? key, required this.carIndex}) : super(key: key);
  final int carIndex;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final homeViewModel = Get.put(HomeViewModel());
  late Future<List<TripModel>> myFuture;

  @override
  void initState() {
    super.initState();
    myFuture = homeViewModel.fetchTrip(widget.carIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('조회하기'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await homeViewModel.fetchTrip(widget.carIndex);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 50,
                      color: Colors.orange,
                      child: Text('운행 이력 조회'),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GetBuilder<HomeViewModel>(builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _.drivingModels.length; i++) ...[
                      Container(
                        width: 150,
                        height: 60,
                        color: Colors.orange,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_.drivingModels[i].tripSeq),
                            Column(
                              children: [
                                for (int j = 0;
                                    j < _.drivingModels[i].data.length;
                                    j++) ...[
                                  Text('colec dt'),
                                  // Text(_.drivingModels[0].data[0].lng),
                                  // Text(
                                  //     'colec dt : ${_.drivingModels[i].data[j].colecDt}'),
                                ],
                                //   Text(
                                //       'colec dt : ${_.drivingModels[i].data[j].colecDt}'),
                                //   Text(
                                //       'lat : ${_.drivingModels[i].data[j].lat}'),
                                //   Text(
                                //       'lng : ${_.drivingModels[i].data[j].lng}'),
                                // ]
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ],
                );
              }),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 50,
                    color: Colors.yellow,
                    child: Text('차량별 trip 조회'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder<List<TripModel>>(
                future: myFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < snapshot.data!.length; i++) ...[
                            GestureDetector(
                              onTap: () async {
                                await homeViewModel.fetchDriving(
                                    widget.carIndex, i);
                              },
                              child: Container(
                                width: 150,
                                height: 60,
                                color: Colors.yellow,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(snapshot.data![i].tripSeq),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 50,
                    color: Colors.green,
                    child: Text('블랙박스 이력 조회'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
