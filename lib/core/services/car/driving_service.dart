import '../common/common_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DrivingService {
  Session session = Session();

  Future<String> fetchDriving() async {
    String url = Session.BASEURL + 'v1/history/basic';
    http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(url)),
      headers: Session.headers,
    );

    print(jsonDecode(response.body));

    // access token 이 만료되었다면 token 을 새로 발급해서 다시 요청합니다.
    if (response.statusCode == 401) {
      await session.refreshTokenHandler();
      http.Response response = await http.get(
        Uri.parse(Uri.encodeFull(url)),
        headers: Session.headers,
      );
      return response.body;
    } else {
      return response.body;
    }
  }

  Future<String> postDriving({
    required String carId,
    required String tripSeq,
    required int onOff,
    required String colecDt,
    required String lat,
    required String lng,
  }) async {
    String url = Session.BASEURL + 'v1/history/basic';
    var data = {
      'car_id': carId,
      'trip_seq': tripSeq,
      'onoff': onOff,
      'data': [
        {
          'colec_dt': colecDt,
          'lat': lat,
          'lng': lng,
        }
      ],
    };

    print(data);

    var body = json.encode(data);

    http.Response response = await http.post(
      Uri.parse(Uri.encodeFull(url)),
      headers: Session.headers,
      body: body,
    );

    print(jsonDecode(response.body));

    // access token 이 만료되었다면 token 을 새로 발급해서 다시 요청합니다.
    if (response.statusCode == 401) {
      await session.refreshTokenHandler();
      http.Response response = await http.get(
        Uri.parse(Uri.encodeFull(url)),
        headers: Session.headers,
      );
      return response.body;
    } else {
      return response.body;
    }
  }
}
