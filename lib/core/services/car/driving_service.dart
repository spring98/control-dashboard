import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../common/common_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class DrivingService {
  Session session = Session();

  Future<String> fetchTrip({required String carId}) async {
    String startDt = DateTime.now().add(Duration(days: -1)).toString();
    String endDt = DateTime.now().toString();

    String url = Session.BASEURL +
        'v1/history/trip?car_id=$carId&start_dt=$startDt&end_dt=$endDt';
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
    required List<Map<String, String>> listData,
    // required String colecDt,
    // required String lat,
    // required String lng,
  }) async {
    String url = Session.BASEURL + 'v1/history/basic';
    var _data = {
      'car_id': carId,
      'trip_seq': tripSeq,
      'onoff': onOff,
      'data': listData,
      // [
      //   {
      //     'colec_dt': colecDt,
      //     'lat': lat,
      //     'lng': lng,
      //   }
      // ],
    };

    Session.headers['Content-Type'] = 'application/json';

    String _body = json.encode(_data);
    http.Response _res = await http.post(
      Uri.parse(Uri.encodeFull(url)),
      headers: Session.headers,
      body: _body,
    );

    print(_res.body);

    // access token 이 만료되었다면 token 을 새로 발급해서 다시 요청합니다.
    if (_res.statusCode == 401) {
      await session.refreshTokenHandler();
      http.Response response = await http.get(
        Uri.parse(Uri.encodeFull(url)),
        headers: Session.headers,
      );
      return response.body;
    } else {
      return _res.body;
    }
  }

  Future<String> fetchDriving(
      {required String carId, required String tripSeq}) async {
    String url =
        Session.BASEURL + 'v1/history/basic?car_id=$carId&trip_seq=$tripSeq';

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

  Future<String> postBlackBox(
      // {required String carId, required String tripSeq}) async {
      {
    required String carId,
    required String path,
    required String tripSeq,
    required String lng,
    required String lat,
  }) async {
    // String tripSeq = DateTime.now().toString();
    String colec_dt =
        DateTime.now().add(Duration(seconds: 1)).toString().split('.')[0];

    Map<String, String> header = Session.headers;
    header['Content-Type'] = 'multipart/form-data';

    String url = Session.BASEURL + 'v1/history/point';

    MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(Uri.encodeFull(url)),
    );

    request.headers.addAll(header);
    request.fields['car_id'] = carId;
    request.fields['trip_seq'] = tripSeq;
    request.fields['colec_dt'] = colec_dt;
    request.fields['lat'] = lat;
    request.fields['lng'] = lng;
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      path,
      contentType: MediaType('image', 'png'),
    ));

    http.Response response =
        await http.Response.fromStream(await request.send());

    print(response.statusCode);
    // print(response.body);

    return response.body;
  }
}
